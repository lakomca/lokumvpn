"""
Pydantic schemas for VPN configuration operations
"""

from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class VPNConfigCreate(BaseModel):
    server_id: int
    dns_servers: Optional[str] = "1.1.1.1,1.0.0.1"

class VPNConfigResponse(BaseModel):
    id: int
    server_id: int
    server_name: str
    server_country: str
    public_key: str
    address: str
    dns_servers: str
    config_content: str
    is_active: bool
    created_at: datetime
    
    model_config = {"from_attributes": True}

class ConnectionRequest(BaseModel):
    config_id: int

class ConnectionStatus(BaseModel):
    is_connected: bool
    server_id: Optional[int] = None
    server_name: Optional[str] = None
    bytes_sent: int = 0
    bytes_received: int = 0
    duration_seconds: int = 0
    connected_at: Optional[datetime] = None

