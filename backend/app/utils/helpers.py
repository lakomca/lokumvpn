"""
Helper utility functions
"""

import re
import socket
import asyncio
import time
from typing import Optional, Tuple

def validate_ip_address(ip: str) -> bool:
    """Validate IP address format"""
    pattern = r'^(\d{1,3}\.){3}\d{1,3}$'
    if not re.match(pattern, ip):
        return False
    parts = ip.split('.')
    return all(0 <= int(part) <= 255 for part in parts)

def validate_domain(domain: str) -> bool:
    """Validate domain name format"""
    pattern = r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'
    return bool(re.match(pattern, domain))

def format_bytes(bytes_count: int) -> str:
    """Format bytes to human-readable format"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_count < 1024.0:
            return f"{bytes_count:.2f} {unit}"
        bytes_count /= 1024.0
    return f"{bytes_count:.2f} PB"

def format_duration(seconds: int) -> str:
    """Format duration in seconds to human-readable format"""
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    secs = seconds % 60
    
    if hours > 0:
        return f"{hours}h {minutes}m {secs}s"
    elif minutes > 0:
        return f"{minutes}m {secs}s"
    else:
        return f"{secs}s"

async def check_server_health(host: str, port: int, timeout: float = 2.0) -> Tuple[bool, float]:
    """
    Check server health by attempting to connect to the WireGuard port
    Returns (is_online, latency_ms)
    """
    try:
        start_time = time.time()
        # Try to create a connection
        reader, writer = await asyncio.wait_for(
            asyncio.open_connection(host, port),
            timeout=timeout
        )
        latency_ms = (time.time() - start_time) * 1000
        writer.close()
        await writer.wait_closed()
        return True, latency_ms
    except (asyncio.TimeoutError, ConnectionRefusedError, OSError, socket.gaierror):
        # Server is not reachable or port is closed
        return False, 0.0
    except Exception:
        # Any other error means server is likely down
        return False, 0.0

async def ping_server(host: str, timeout: float = 1.0) -> Tuple[bool, float]:
    """
    Simple ping-like check using ICMP (if available) or TCP connection
    Returns (is_reachable, latency_ms)
    """
    try:
        start_time = time.time()
        # Try ICMP ping first (requires root on Linux)
        proc = await asyncio.create_subprocess_exec(
            'ping', '-c', '1', '-W', str(int(timeout * 1000)), host,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        await asyncio.wait_for(proc.wait(), timeout=timeout + 0.5)
        latency_ms = (time.time() - start_time) * 1000
        
        if proc.returncode == 0:
            return True, latency_ms
        else:
            # Fallback to TCP connection check
            return await check_server_health(host, 80, timeout)
    except (asyncio.TimeoutError, FileNotFoundError, PermissionError):
        # ping command not available or no permission, fallback to TCP
        return await check_server_health(host, 80, timeout)
    except Exception:
        return False, 0.0




