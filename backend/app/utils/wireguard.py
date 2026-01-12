"""
WireGuard utility functions for key generation and config creation
"""

from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey, X25519PublicKey
from cryptography.hazmat.primitives import serialization
import base64
import ipaddress

def generate_keypair():
    """Generate a WireGuard keypair"""
    private_key = X25519PrivateKey.generate()
    public_key = private_key.public_key()
    
    # Serialize private key
    private_bytes = private_key.private_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PrivateFormat.Raw,
        encryption_algorithm=serialization.NoEncryption()
    )
    private_key_b64 = base64.b64encode(private_bytes).decode('ascii')
    
    # Serialize public key
    public_bytes = public_key.public_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PublicFormat.Raw
    )
    public_key_b64 = base64.b64encode(public_bytes).decode('ascii')
    
    return private_key_b64, public_key_b64

def generate_client_ip(server_network: str, index: int) -> str:
    """Generate a client IP address within the server's network"""
    network = ipaddress.IPv4Network(server_network, strict=False)
    # Use index+2 to avoid network and gateway addresses
    if index + 2 < network.num_addresses:
        return str(list(network.hosts())[index])
    raise ValueError("Too many clients for this network")

def create_wireguard_config(
    private_key: str,
    server_public_key: str,
    server_endpoint: str,
    server_port: int,
    client_ip: str,
    dns_servers: str = "1.1.1.1,1.0.0.1",
    allowed_ips: str = "0.0.0.0/0,::/0"
) -> str:
    """Create a WireGuard configuration file content"""
    config = f"""[Interface]
PrivateKey = {private_key}
Address = {client_ip}/32
DNS = {dns_servers}

[Peer]
PublicKey = {server_public_key}
Endpoint = {server_endpoint}:{server_port}
AllowedIPs = {allowed_ips}
PersistentKeepalive = 25
"""
    return config.strip()





