# Lokum VPN API Documentation

## Base URL

```
http://localhost:8000/api/v1
```

## Authentication

Most endpoints require Bearer token authentication:

```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

## Endpoints

### Authentication

#### Register User
```http
POST /auth/register
Content-Type: application/json

{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "username": "string",
  "password": "string"
}

Response:
{
  "access_token": "string",
  "token_type": "bearer"
}
```

#### Get Current User
```http
GET /auth/me
Authorization: Bearer TOKEN
```

### VPN Servers

#### List Servers
```http
GET /servers/?country=US&active_only=true
Authorization: Bearer TOKEN

Response:
{
  "servers": [...],
  "total": 10
}
```

#### Get Server Details
```http
GET /servers/{server_id}
Authorization: Bearer TOKEN
```

#### Get Server Status
```http
GET /servers/{server_id}/status
Authorization: Bearer TOKEN

Response:
{
  "server_id": 1,
  "is_online": true,
  "load_percentage": 45.5,
  "latency_ms": 23.4,
  "current_users": 25
}
```

#### List Countries
```http
GET /servers/countries
Authorization: Bearer TOKEN

Response:
{
  "countries": [
    {
      "code": "US",
      "name": "United States",
      "server_count": 5
    }
  ]
}
```

### VPN Configuration

#### Create Configuration
```http
POST /config/
Authorization: Bearer TOKEN
Content-Type: application/json

{
  "server_id": 1,
  "dns_servers": "1.1.1.1,1.0.0.1"  # Optional
}

Response:
{
  "id": 1,
  "server_id": 1,
  "server_name": "US East",
  "server_country": "United States",
  "public_key": "...",
  "address": "10.0.0.2/32",
  "dns_servers": "1.1.1.1,1.0.0.1",
  "config_content": "[Interface]...",
  "is_active": true,
  "created_at": "2024-01-01T00:00:00"
}
```

#### List Configurations
```http
GET /config/
Authorization: Bearer TOKEN
```

#### Get Configuration
```http
GET /config/{config_id}
Authorization: Bearer TOKEN
```

#### Delete Configuration
```http
DELETE /config/{config_id}
Authorization: Bearer TOKEN
```

### Connection Management

#### Connect to VPN
```http
POST /config/connect
Authorization: Bearer TOKEN
Content-Type: application/json

{
  "config_id": 1
}
```

#### Disconnect from VPN
```http
POST /config/disconnect
Authorization: Bearer TOKEN
```

#### Get Connection Status
```http
GET /config/status
Authorization: Bearer TOKEN

Response:
{
  "is_connected": true,
  "server_id": 1,
  "server_name": "US East",
  "bytes_sent": 1024000,
  "bytes_received": 2048000,
  "duration_seconds": 3600,
  "connected_at": "2024-01-01T00:00:00"
}
```

### Statistics

#### Get Summary Statistics
```http
GET /stats/summary
Authorization: Bearer TOKEN

Response:
{
  "total_connections": 50,
  "active_connection": true,
  "total_data_mb": 1024.5,
  "total_data_gb": 1.0,
  "total_time_hours": 24.5,
  "connections_today": 3,
  "current_server": 1
}
```

#### Get Usage Statistics
```http
GET /stats/usage?days=7
Authorization: Bearer TOKEN

Response:
{
  "period_days": 7,
  "daily_stats": [
    {
      "date": "2024-01-01",
      "connections": 5,
      "data_mb": 512.0,
      "duration_hours": 8.5
    }
  ]
}
```

### Protection

#### Get Protection Statistics
```http
GET /protection/stats
Authorization: Bearer TOKEN

Response:
{
  "adblock_domains": 50000,
  "malware_domains": 75000,
  "adblock_last_update": "2024-01-01T00:00:00",
  "malware_last_update": "2024-01-01T00:00:00"
}
```

#### Check Domain
```http
POST /protection/check
Authorization: Bearer TOKEN
Content-Type: application/json

{
  "domain": "example.com"
}

Response:
{
  "domain": "example.com",
  "blocked": false,
  "reason": ""
}
```

#### Get Protection Status
```http
GET /protection/status
Authorization: Bearer TOKEN

Response:
{
  "adblock_enabled": true,
  "malware_protection_enabled": true,
  "adblock_needs_update": false,
  "malware_needs_update": false,
  "adblock_count": 50000,
  "malware_count": 75000
}
```

#### Update Ad Block List (Admin Only)
```http
POST /protection/update/adblock
Authorization: Bearer ADMIN_TOKEN
```

#### Update Malware List (Admin Only)
```http
POST /protection/update/malware
Authorization: Bearer ADMIN_TOKEN
```

## Error Responses

All errors follow this format:

```json
{
  "detail": "Error message here"
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

## Rate Limiting

API endpoints may be rate-limited in production. Check response headers:
- `X-RateLimit-Limit`: Maximum requests per window
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-RateLimit-Reset`: Time when limit resets

## Interactive API Documentation

When the backend is running, visit:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

