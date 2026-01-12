"""
Pydantic schemas
"""

from app.schemas.user import UserBase, UserCreate, UserLogin, UserResponse, Token, TokenData
from app.schemas.server import (
    VPNServerBase, VPNServerCreate, VPNServerResponse, 
    VPNServerListResponse, ServerStatus
)
from app.schemas.config import (
    VPNConfigCreate, VPNConfigResponse, ConnectionRequest, ConnectionStatus
)

__all__ = [
    "UserBase", "UserCreate", "UserLogin", "UserResponse", "Token", "TokenData",
    "VPNServerBase", "VPNServerCreate", "VPNServerResponse", 
    "VPNServerListResponse", "ServerStatus",
    "VPNConfigCreate", "VPNConfigResponse", "ConnectionRequest", "ConnectionStatus"
]





