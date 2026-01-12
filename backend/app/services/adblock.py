"""
Ad blocking service
"""

import requests
import os
from datetime import datetime, timedelta
from typing import Set
from pathlib import Path
from app.core.config import settings

class AdBlockService:
    def __init__(self):
        self.blocklist_path = Path(settings.VPN_MANAGEMENT_PATH) / "adblock_hosts.txt"
        self.blocklist: Set[str] = set()
        self.last_update: datetime = None
        self.ensure_directory()
    
    def ensure_directory(self):
        """Ensure the management directory exists"""
        self.blocklist_path.parent.mkdir(parents=True, exist_ok=True)
    
    async def update_blocklist(self) -> bool:
        """Update the ad blocking blocklist from remote source"""
        try:
            response = requests.get(settings.ADBLOCK_LIST_URL, timeout=30)
            response.raise_for_status()
            
            domains = set()
            for line in response.text.splitlines():
                line = line.strip()
                # Skip comments and empty lines
                if line and not line.startswith('#'):
                    parts = line.split()
                    if len(parts) >= 2:
                        # Extract domain from hosts file format (IP domain)
                        domain = parts[1] if len(parts) > 1 else parts[0]
                        if domain and not domain.startswith('#'):
                            domains.add(domain)
            
            self.blocklist = domains
            self.last_update = datetime.utcnow()
            
            # Save to file
            with open(self.blocklist_path, 'w') as f:
                for domain in sorted(domains):
                    f.write(f"{domain}\n")
            
            return True
        except Exception as e:
            print(f"Error updating adblock list: {e}")
            return False
    
    async def load_blocklist(self) -> bool:
        """Load blocklist from file"""
        if self.blocklist_path.exists():
            try:
                with open(self.blocklist_path, 'r') as f:
                    self.blocklist = {line.strip() for line in f if line.strip()}
                return True
            except Exception as e:
                print(f"Error loading adblock list: {e}")
                return False
        return False
    
    async def should_block(self, domain: str) -> bool:
        """Check if a domain should be blocked"""
        if not self.blocklist:
            await self.load_blocklist()
        
        # Check if domain or any parent domain is in blocklist
        parts = domain.split('.')
        for i in range(len(parts)):
            check_domain = '.'.join(parts[i:])
            if check_domain in self.blocklist:
                return True
        return False
    
    async def get_blocklist_count(self) -> int:
        """Get the number of blocked domains"""
        if not self.blocklist:
            await self.load_blocklist()
        return len(self.blocklist)
    
    async def needs_update(self) -> bool:
        """Check if blocklist needs updating"""
        if not self.last_update:
            return True
        
        age = datetime.utcnow() - self.last_update
        return age.total_seconds() > settings.ADBLOCK_UPDATE_INTERVAL

adblock_service = AdBlockService()





