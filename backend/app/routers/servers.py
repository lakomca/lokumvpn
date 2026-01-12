"""
VPN Servers router
"""

from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.database import get_db
from app.models.user import User
from app.models.vpn_server import VPNServer
from app.schemas.server import VPNServerCreate, VPNServerResponse, VPNServerListResponse, ServerStatus
from app.routers.auth import get_current_user
from app.utils.helpers import check_server_health, ping_server

router = APIRouter()

@router.get("/", response_model=VPNServerListResponse)
async def list_servers(
    country: Optional[str] = Query(None, description="Filter by country code"),
    active_only: bool = Query(True, description="Show only active servers"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """List all available VPN servers"""
    query = db.query(VPNServer)
    
    if active_only:
        query = query.filter(VPNServer.is_active == True)
    
    if country:
        query = query.filter(VPNServer.country_code == country.upper())
    
    servers = query.order_by(VPNServer.country, VPNServer.name).all()
    
    return VPNServerListResponse(
        servers=[VPNServerResponse.model_validate(s) for s in servers],
        total=len(servers)
    )

@router.get("/countries")
async def list_countries(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """List all available countries with server counts"""
    servers = db.query(VPNServer).filter(VPNServer.is_active == True).all()
    
    countries = {}
    for server in servers:
        if server.country_code not in countries:
            countries[server.country_code] = {
                "code": server.country_code,
                "name": server.country,
                "server_count": 0
            }
        countries[server.country_code]["server_count"] += 1
    
    return {"countries": list(countries.values())}

@router.get("/{server_id}", response_model=VPNServerResponse)
async def get_server(
    server_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get details of a specific VPN server"""
    server = db.query(VPNServer).filter(VPNServer.id == server_id).first()
    
    if not server:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Server not found"
        )
    
    return VPNServerResponse.model_validate(server)

@router.get("/{server_id}/status", response_model=ServerStatus)
async def get_server_status(
    server_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get real-time status of a VPN server"""
    server = db.query(VPNServer).filter(VPNServer.id == server_id).first()
    
    if not server:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Server not found"
        )
    
    # Check server health (ping and port check)
    is_online, latency_ms = await check_server_health(server.ip_address, server.port, timeout=2.0)
    
    # Update server status in database (non-blocking update)
    try:
        server.latency_ms = latency_ms if is_online else 999.0
        server.is_active = is_online and server.is_active  # Don't activate if it was manually disabled
        if latency_ms > 0:
            db.commit()
    except Exception:
        # If update fails, continue with current values
        db.rollback()
        pass
    
    # Calculate load percentage based on current users
    load_percentage = (server.current_users / server.max_users * 100) if server.max_users > 0 else 0.0
    
    return ServerStatus(
        server_id=server.id,
        is_online=is_online and server.is_active,
        load_percentage=min(load_percentage, 100.0),
        latency_ms=latency_ms if is_online else 0.0,
        current_users=server.current_users
    )

@router.post("/", response_model=VPNServerResponse, status_code=status.HTTP_201_CREATED)
async def create_server(
    server_data: VPNServerCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new VPN server (admin only)"""
    if not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    # Check if hostname already exists
    existing = db.query(VPNServer).filter(VPNServer.hostname == server_data.hostname).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Server with this hostname already exists"
        )
    
    db_server = VPNServer(**server_data.model_dump())
    db.add(db_server)
    db.commit()
    db.refresh(db_server)
    
    return VPNServerResponse.model_validate(db_server)

