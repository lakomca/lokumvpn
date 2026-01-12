"""
VPN Server models
"""

from sqlalchemy import Column, Integer, String, Boolean, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class VPNServer(Base):
    __tablename__ = "vpn_servers"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    country = Column(String, nullable=False)
    country_code = Column(String(2), nullable=False)
    region = Column(String, nullable=True)
    hostname = Column(String, nullable=False, unique=True)
    ip_address = Column(String, nullable=False)
    ipv6_address = Column(String, nullable=True)
    port = Column(Integer, default=51820)
    public_key = Column(String, nullable=False)
    endpoint = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    load_percentage = Column(Float, default=0.0)
    latency_ms = Column(Float, default=0.0)
    bandwidth_mbps = Column(Float, default=1000.0)
    max_users = Column(Integer, default=100)
    current_users = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    configs = relationship("VPNConfig", back_populates="server")
    connections = relationship("Connection", back_populates="server")

class VPNConfig(Base):
    __tablename__ = "vpn_configs"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    server_id = Column(Integer, ForeignKey("vpn_servers.id"), nullable=False)
    private_key = Column(String, nullable=False)
    public_key = Column(String, nullable=False)
    address = Column(String, nullable=False)  # Client IP in VPN network
    dns_servers = Column(String, default="1.1.1.1,1.0.0.1")
    config_content = Column(String, nullable=False)  # Full WireGuard config
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="vpn_configs")
    server = relationship("VPNServer", back_populates="configs")
    connections = relationship("Connection", back_populates="config")

class Connection(Base):
    __tablename__ = "connections"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    server_id = Column(Integer, ForeignKey("vpn_servers.id"), nullable=False)
    config_id = Column(Integer, ForeignKey("vpn_configs.id"), nullable=False)
    connected_at = Column(DateTime, default=datetime.utcnow)
    disconnected_at = Column(DateTime, nullable=True)
    bytes_sent = Column(Integer, default=0)
    bytes_received = Column(Integer, default=0)
    duration_seconds = Column(Integer, default=0)
    is_active = Column(Boolean, default=False)
    
    # Relationships
    user = relationship("User", back_populates="connections")
    server = relationship("VPNServer", back_populates="connections")
    config = relationship("VPNConfig", back_populates="connections")





