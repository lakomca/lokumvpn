"""
Lokum VPN Backend API
Main FastAPI application for VPN service management
"""

from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
from contextlib import asynccontextmanager
import os
from dotenv import load_dotenv

from app.database import init_db
from app.routers import auth, servers, config, stats, protection
from app.core.config import settings

# Load environment variables
load_dotenv()

security = HTTPBearer()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await init_db()
    yield
    # Shutdown
    pass

app = FastAPI(
    title="Lokum VPN API",
    description="Backend API for Lokum VPN service",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(servers.router, prefix="/api/v1/servers", tags=["Servers"])
app.include_router(config.router, prefix="/api/v1/config", tags=["Configuration"])
app.include_router(stats.router, prefix="/api/v1/stats", tags=["Statistics"])
app.include_router(protection.router, prefix="/api/v1/protection", tags=["Protection"])

@app.get("/")
async def root():
    return {
        "service": "Lokum VPN API",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.API_HOST,
        port=settings.API_PORT,
        reload=True
    )





