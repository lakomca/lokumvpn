"""
Statistics router
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func
from datetime import datetime, timedelta

from app.database import get_db
from app.models.user import User
from app.models.vpn_server import Connection
from app.routers.auth import get_current_user_or_guest

router = APIRouter()

@router.get("/summary")
async def get_stats_summary(
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Get user statistics summary"""
    # Total connections
    total_connections = db.query(Connection).filter(
        Connection.user_id == current_user.id
    ).count()
    
    # Active connection
    active_connection = db.query(Connection).filter(
        Connection.user_id == current_user.id,
        Connection.is_active == True
    ).first()
    
    # Total data usage
    total_bytes = db.query(
        func.sum(Connection.bytes_sent + Connection.bytes_received)
    ).filter(Connection.user_id == current_user.id).scalar() or 0
    
    # Total connection time
    total_seconds = db.query(func.sum(Connection.duration_seconds)).filter(
        Connection.user_id == current_user.id
    ).scalar() or 0
    
    # Connections today
    today = datetime.utcnow().date()
    today_connections = db.query(Connection).filter(
        Connection.user_id == current_user.id,
        func.date(Connection.connected_at) == today
    ).count()
    
    return {
        "total_connections": total_connections,
        "active_connection": active_connection is not None,
        "total_data_mb": round(total_bytes / (1024 * 1024), 2),
        "total_data_gb": round(total_bytes / (1024 * 1024 * 1024), 2),
        "total_time_hours": round(total_seconds / 3600, 2),
        "connections_today": today_connections,
        "current_server": active_connection.server_id if active_connection else None
    }

@router.get("/usage")
async def get_usage_stats(
    days: int = 7,
    current_user: User = Depends(get_current_user_or_guest),
    db: Session = Depends(get_db)
):
    """Get usage statistics for the last N days"""
    start_date = datetime.utcnow() - timedelta(days=days)
    
    connections = db.query(Connection).filter(
        Connection.user_id == current_user.id,
        Connection.connected_at >= start_date
    ).order_by(Connection.connected_at.desc()).all()
    
    daily_stats = {}
    for conn in connections:
        date_key = conn.connected_at.date().isoformat()
        if date_key not in daily_stats:
            daily_stats[date_key] = {
                "date": date_key,
                "connections": 0,
                "data_mb": 0,
                "duration_hours": 0
            }
        daily_stats[date_key]["connections"] += 1
        daily_stats[date_key]["data_mb"] += (conn.bytes_sent + conn.bytes_received) / (1024 * 1024)
        daily_stats[date_key]["duration_hours"] += conn.duration_seconds / 3600
    
    return {
        "period_days": days,
        "daily_stats": list(daily_stats.values())
    }





