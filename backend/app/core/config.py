"""
Configuration settings for Lokum VPN Backend
"""

from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import List
import os

class Settings(BaseSettings):
    # API Settings
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 1440
    
    # Database
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./lokum_vpn.db")
    
    # Redis
    REDIS_HOST: str = os.getenv("REDIS_HOST", "localhost")
    REDIS_PORT: int = int(os.getenv("REDIS_PORT", "6379"))
    REDIS_DB: int = int(os.getenv("REDIS_DB", "0"))
    
    # API Server
    API_HOST: str = os.getenv("API_HOST", "0.0.0.0")
    API_PORT: int = int(os.getenv("API_PORT", "8000"))
    CORS_ORIGINS: List[str] = ["*"]
    
    # VPN Configuration
    VPN_WG_CONFIG_PATH: str = os.getenv("VPN_WG_CONFIG_PATH", "/etc/wireguard")
    VPN_MANAGEMENT_PATH: str = os.getenv("VPN_MANAGEMENT_PATH", "/var/lib/lokum-vpn")
    
    # Ad Blocking
    ADBLOCK_LIST_URL: str = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    ADBLOCK_UPDATE_INTERVAL: int = 86400
    
    # Malware Protection
    MALWARE_LIST_URL: str = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
    MALWARE_UPDATE_INTERVAL: int = 86400
    
    # Server Management
    VPN_SERVER_REGION_DEFAULT: str = "US"
    MAX_SERVERS_PER_USER: int = 5
    
    model_config = SettingsConfigDict(
        env_file=".env",
        case_sensitive=True,
        extra="ignore"
    )

settings = Settings()

