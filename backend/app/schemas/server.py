"""
Pydantic schemas for VPN server operations
"""

from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class VPNServerBase(BaseModel):
    name: str
    country: str
    country_code: str
    region: Optional[str] = None
    hostname: str
    ip_address: str
    ipv6_address: Optional[str] = None
    port: int = 51820
    public_key: str
    endpoint: str

class VPNServerCreate(VPNServerBase):
    pass

class VPNServerResponse(VPNServerBase):
    id: int
    is_active: bool
    load_percentage: float
    latency_ms: float
    bandwidth_mbps: float
    max_users: int
    current_users: int
    created_at: datetime
    
    model_config = {"from_attributes": True}

class VPNServerListResponse(BaseModel):
    servers: list[VPNServerResponse]
    total: int

class ServerStatus(BaseModel):
    server_id: int
    is_online: bool
    load_percentage: float
    latency_ms: float
    current_users: int

