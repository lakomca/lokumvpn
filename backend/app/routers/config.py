"""
VPN Configuration router
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.user import User
from app.models.vpn_server import VPNServer, VPNConfig, Connection
from app.schemas.config import VPNConfigCreate, VPNConfigResponse, ConnectionRequest, ConnectionStatus
from app.routers.auth import get_current_user_or_guest
from app.utils.wireguard import generate_keypair, generate_client_ip, create_wireguard_config
from app.core.config import settings

router = APIRouter()

@router.post("/", response_model=VPNConfigResponse, status_code=status.HTTP_201_CREATED)
async def create_config(
    config_data: VPNConfigCreate,
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Create a new VPN configuration for a server"""
    # Check if user has reached max configs limit
    user_configs = db.query(VPNConfig).filter(VPNConfig.user_id == current_user.id).count()
    if user_configs >= settings.MAX_SERVERS_PER_USER:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Maximum {settings.MAX_SERVERS_PER_USER} configurations allowed per user"
        )
    
    # Verify server exists and is active
    server = db.query(VPNServer).filter(VPNServer.id == config_data.server_id).first()
    if not server:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Server not found"
        )
    
    if not server.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Server is not active"
        )
    
    # Check if user already has a config for this server
    existing = db.query(VPNConfig).filter(
        VPNConfig.user_id == current_user.id,
        VPNConfig.server_id == config_data.server_id
    ).first()
    
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Configuration already exists for this server"
        )
    
    # Generate WireGuard keys
    private_key, public_key = generate_keypair()
    
    # Generate client IP (using a simple allocation scheme)
    existing_configs_count = db.query(VPNConfig).filter(
        VPNConfig.server_id == config_data.server_id
    ).count()
    
    # Default network: 10.0.0.0/8 subnet per server
    # Each server gets 10.{server_id}.0.0/16
    server_network = f"10.{server.id}.0.0/16"
    client_ip = generate_client_ip(server_network, existing_configs_count)
    
    # Create WireGuard config content
    config_content = create_wireguard_config(
        private_key=private_key,
        server_public_key=server.public_key,
        server_endpoint=server.endpoint,
        server_port=server.port,
        client_ip=client_ip,
        dns_servers=config_data.dns_servers
    )
    
    # Create database record
    db_config = VPNConfig(
        user_id=current_user.id,
        server_id=config_data.server_id,
        private_key=private_key,
        public_key=public_key,
        address=client_ip,
        dns_servers=config_data.dns_servers,
        config_content=config_content
    )
    
    db.add(db_config)
    db.commit()
    db.refresh(db_config)
    
    return VPNConfigResponse(
        id=db_config.id,
        server_id=server.id,
        server_name=server.name,
        server_country=server.country,
        public_key=public_key,
        address=client_ip,
        dns_servers=config_data.dns_servers,
        config_content=config_content,
        is_active=db_config.is_active,
        created_at=db_config.created_at
    )

@router.get("/", response_model=list[VPNConfigResponse])
async def list_configs(
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """List all VPN configurations for current user"""
    configs = db.query(VPNConfig).filter(VPNConfig.user_id == current_user.id).all()
    
    result = []
    for config in configs:
        server = db.query(VPNServer).filter(VPNServer.id == config.server_id).first()
        result.append(VPNConfigResponse(
            id=config.id,
            server_id=config.server_id,
            server_name=server.name if server else "Unknown",
            server_country=server.country if server else "Unknown",
            public_key=config.public_key,
            address=config.address,
            dns_servers=config.dns_servers,
            config_content=config.config_content,
            is_active=config.is_active,
            created_at=config.created_at
        ))
    
    return result

@router.get("/{config_id}", response_model=VPNConfigResponse)
async def get_config(
    config_id: int,
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Get a specific VPN configuration"""
    config = db.query(VPNConfig).filter(
        VPNConfig.id == config_id,
        VPNConfig.user_id == current_user.id
    ).first()
    
    if not config:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Configuration not found"
        )
    
    server = db.query(VPNServer).filter(VPNServer.id == config.server_id).first()
    return VPNConfigResponse(
        id=config.id,
        server_id=config.server_id,
        server_name=server.name if server else "Unknown",
        server_country=server.country if server else "Unknown",
        public_key=config.public_key,
        address=config.address,
        dns_servers=config.dns_servers,
        config_content=config.config_content,
        is_active=config.is_active,
        created_at=config.created_at
    )

@router.delete("/{config_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_config(
    config_id: int,
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Delete a VPN configuration"""
    config = db.query(VPNConfig).filter(
        VPNConfig.id == config_id,
        VPNConfig.user_id == current_user.id
    ).first()
    
    if not config:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Configuration not found"
        )
    
    db.delete(config)
    db.commit()
    
    return None

@router.post("/connect", response_model=ConnectionStatus)
async def connect_vpn(
    connection_request: ConnectionRequest,
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Establish a VPN connection"""
    config = db.query(VPNConfig).filter(
        VPNConfig.id == connection_request.config_id,
        VPNConfig.user_id == current_user.id
    ).first()
    
    if not config:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Configuration not found"
        )
    
    # Check for existing active connection
    existing = db.query(Connection).filter(
        Connection.user_id == current_user.id,
        Connection.is_active == True
    ).first()
    
    if existing:
        # Disconnect existing connection
        existing.is_active = False
        from datetime import datetime
        existing.disconnected_at = datetime.utcnow()
    
    # Create new connection record
    connection = Connection(
        user_id=current_user.id,
        server_id=config.server_id,
        config_id=config.id,
        is_active=True
    )
    
    db.add(connection)
    
    # Update server user count
    server = db.query(VPNServer).filter(VPNServer.id == config.server_id).first()
    if server:
        server.current_users += 1
    
    db.commit()
    db.refresh(connection)
    
    return ConnectionStatus(
        is_connected=True,
        server_id=config.server_id,
        server_name=server.name if server else "Unknown",
        bytes_sent=0,
        bytes_received=0,
        duration_seconds=0,
        connected_at=connection.connected_at
    )

@router.post("/disconnect", response_model=ConnectionStatus)
async def disconnect_vpn(
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Disconnect current VPN connection"""
    connection = db.query(Connection).filter(
        Connection.user_id == current_user.id,
        Connection.is_active == True
    ).first()
    
    if not connection:
        return ConnectionStatus(is_connected=False)
    
    # Update connection
    from datetime import datetime
    connection.is_active = False
    connection.disconnected_at = datetime.utcnow()
    
    # Update server user count
    server = db.query(VPNServer).filter(VPNServer.id == connection.server_id).first()
    if server and server.current_users > 0:
        server.current_users -= 1
    
    db.commit()
    
    return ConnectionStatus(is_connected=False)

@router.get("/status", response_model=ConnectionStatus)
async def get_connection_status(
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Get current VPN connection status with real-time duration calculation"""
    from datetime import datetime
    
    connection = db.query(Connection).filter(
        Connection.user_id == current_user.id,
        Connection.is_active == True
    ).first()
    
    if not connection:
        return ConnectionStatus(is_connected=False)
    
    server = db.query(VPNServer).filter(VPNServer.id == connection.server_id).first()
    
    # Calculate duration dynamically
    duration_seconds = 0
    if connection.connected_at:
        duration_delta = datetime.utcnow() - connection.connected_at
        duration_seconds = int(duration_delta.total_seconds())
    
    # Update connection record with calculated duration
    connection.duration_seconds = duration_seconds
    try:
        db.commit()
    except Exception:
        db.rollback()
    
    return ConnectionStatus(
        is_connected=True,
        server_id=connection.server_id,
        server_name=server.name if server else "Unknown",
        bytes_sent=connection.bytes_sent,
        bytes_received=connection.bytes_received,
        duration_seconds=duration_seconds,
        connected_at=connection.connected_at
    )




