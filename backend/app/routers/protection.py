"""
Ad blocking and malware protection router
"""

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Dict

from app.models.user import User
from app.routers.auth import get_current_user
from app.services.adblock import adblock_service
from app.services.malware import malware_service

router = APIRouter()

class BlockCheckRequest(BaseModel):
    domain: str

class BlockCheckResponse(BaseModel):
    domain: str
    blocked: bool
    reason: str = ""

class ProtectionStats(BaseModel):
    adblock_domains: int
    malware_domains: int
    adblock_last_update: str = ""
    malware_last_update: str = ""

@router.get("/stats", response_model=ProtectionStats)
async def get_protection_stats(
    current_user: User = Depends(get_current_user)
):
    """Get ad blocking and malware protection statistics"""
    adblock_count = await adblock_service.get_blocklist_count()
    malware_count = await malware_service.get_blocklist_count()
    
    adblock_last = adblock_service.last_update.isoformat() if adblock_service.last_update else ""
    malware_last = malware_service.last_update.isoformat() if malware_service.last_update else ""
    
    return ProtectionStats(
        adblock_domains=adblock_count,
        malware_domains=malware_count,
        adblock_last_update=adblock_last,
        malware_last_update=malware_last
    )

@router.post("/check", response_model=BlockCheckResponse)
async def check_domain(
    request: BlockCheckRequest,
    current_user: User = Depends(get_current_user)
):
    """Check if a domain should be blocked"""
    domain = request.domain.lower().strip()
    
    # Check malware/phishing first (higher priority)
    if await malware_service.should_block(domain):
        return BlockCheckResponse(
            domain=domain,
            blocked=True,
            reason="malware_phishing"
        )
    
    # Check ad blocking
    if await adblock_service.should_block(domain):
        return BlockCheckResponse(
            domain=domain,
            blocked=True,
            reason="advertising"
        )
    
    return BlockCheckResponse(
        domain=domain,
        blocked=False,
        reason=""
    )

@router.post("/update/adblock")
async def update_adblock_list(
    current_user: User = Depends(get_current_user)
):
    """Update ad blocking blocklist (admin only)"""
    if not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    success = await adblock_service.update_blocklist()
    if success:
        return {"message": "Ad blocklist updated successfully", "count": len(adblock_service.blocklist)}
    else:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update ad blocklist"
        )

@router.post("/update/malware")
async def update_malware_list(
    current_user: User = Depends(get_current_user)
):
    """Update malware protection blocklist (admin only)"""
    if not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    success = await malware_service.update_blocklist()
    if success:
        return {"message": "Malware blocklist updated successfully", "count": len(malware_service.blocklist)}
    else:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update malware blocklist"
        )

@router.get("/status")
async def get_protection_status(
    current_user: User = Depends(get_current_user)
):
    """Get protection feature status"""
    adblock_needs_update = await adblock_service.needs_update()
    malware_needs_update = await malware_service.needs_update()
    
    return {
        "adblock_enabled": True,
        "malware_protection_enabled": True,
        "adblock_needs_update": adblock_needs_update,
        "malware_needs_update": malware_needs_update,
        "adblock_count": await adblock_service.get_blocklist_count(),
        "malware_count": await malware_service.get_blocklist_count()
    }





