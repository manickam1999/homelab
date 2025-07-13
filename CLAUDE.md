# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Docker-based homelab infrastructure organized into three specialized stacks:

- **core/**: Essential infrastructure services (Traefik, Pi-hole, Homepage, etc.)
- **media-stack/**: Complete media automation pipeline (Jellyfin, Sonarr, Radarr, qBittorrent, etc.)
- **tools/**: Utility services (Stirling PDF, Calibre, Paperless, Firefly III, etc.)

Each stack is independently deployable with its own docker-compose file and can be managed separately.

## Common Commands

### Stack Management
```bash
# Start any stack
cd [stack-directory]
docker-compose up -d

# Stop stack
docker-compose down

# Update containers
docker-compose pull && docker-compose up -d

# View logs
docker-compose logs -f [service-name]

# Restart specific service
docker-compose restart [service-name]
```

### Network Setup
```bash
# Setup Pi-hole macvlan network (run once)
sudo ./core/setup-pihole-network.sh

# Create external networks (if needed)
docker network create core_net
docker network create media_net
docker network create tools_net
```

### Environment Configuration
- Each stack has its own `.env` file for configuration
- Copy `.env.example` to `.env` in each stack directory before first run
- Global settings like TZ, PUID, PGID are defined in stack-specific .env files

## Service Architecture

### Core Stack Services
- **Traefik**: Reverse proxy and load balancer (ports 80, 9000)
- **Pi-hole**: DNS sinkhole using macvlan network (192.168.100.149)
- **Homepage**: Service dashboard (port 3000)
- **Uptime Kuma**: Monitoring (port 3001)
- **Dockge**: Docker stack management (port 5001)
- **Watchtower**: Automated container updates
- **FileBrowser**: File management interface

### Media Stack Services
- **Jellyfin**: Media server (port 8096) with hardware acceleration
- **Sonarr**: TV show management (port 8989)
- **Radarr**: Movie management (port 7878)
- **Prowlarr**: Indexer manager (port 9696)
- **qBittorrent**: Download client (port 8080)
- **Jellyseerr**: Request management (port 5055)
- **Bazarr**: Subtitle management (port 6767)
- **Autobrr**: Automated downloading (port 7474)

### Tools Stack Services
- **Stirling PDF**: PDF manipulation (port 8181)
- **Calibre**: E-book management suite (ports 8083-8086)
- **Paperless**: Document management with OCR (integrated PostgreSQL/Redis)
- **Firefly III**: Personal finance manager (port 8087)

## Key Configuration Details

### Domain Routing
All services use `.home` domains routed through Traefik:
- `jellyfin.home`, `sonarr.home`, `radarr.home`, etc.
- Homepage accessible at `home.home`

### Storage Paths
- Media content: `/mnt/homelab/media-stack/`
- Application configs: `./config/[service]/` in each stack
- Downloads: `/mnt/homelab/media-stack/downloads/`

### Networking
- **core_net**: Core infrastructure services
- **media_net**: Media stack services  
- **tools_net**: Utility services
- **pihole_network**: Dedicated macvlan for Pi-hole

### User/Group Settings
- PUID=1000, PGID=1000 (configurable in .env files)
- Consistent across all LinuxServer.io containers

## Special Setup Requirements

### Pi-hole Network
Requires macvlan setup for proper DNS functionality:
```bash
sudo ./core/setup-pihole-network.sh
```

### Hardware Acceleration (Jellyfin)
- Device mapping: `/dev/dri:/dev/dri`
- Group access: video(44), render(110)

### File Permissions
- Some database directories require specific ownership
- Use `sudo chown -R ${PUID}:${PGID}` if permission issues occur

## Troubleshooting

### Network Issues
- Ensure external networks exist before stack startup
- Verify macvlan interface for Pi-hole communication

### Service Dependencies
- Media stack services depend on core network being available
- Jellyseerr requires Jellyfin and Sonarr/Radarr to be configured first

### Storage Issues
- Verify mount points exist: `/mnt/homelab/`
- Check directory permissions for application data

## Security Notes
- Pi-hole admin password is hardcoded in docker-compose (change immediately)
- API keys stored in .env files - never commit these to version control
- Services exposed only to internal network via Traefik