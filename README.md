# Homelab Infrastructure

A comprehensive homelab setup using Docker containers, organized into specialized stacks for different purposes.

## Overview

This homelab infrastructure is designed to provide:
- Media server capabilities with automation
- Core infrastructure services
- Utility tools for various purposes

## Directory Structure

```
homelab/
├── core/           # Core infrastructure services
├── media-stack/    # Media server and automation tools
└── tools/          # Utility tools and services
```

## Stack Descriptions

### Core Stack
Located in `core/`, this stack handles essential infrastructure services. Contains:
- Docker configurations
- Core system configurations
- Data storage management

### Media Stack
Located in `media-stack/`, this comprehensive media server solution includes:
- Jellyfin (Media Server)
- Sonarr (TV Shows)
- Radarr (Movies)
- Prowlarr (Indexer)
- Jackett (Additional Indexer)
- qBittorrent (Download Client)
- Jellyseerr (Request Management)
- Suggestarr (Media Suggestions)

Detailed setup instructions are available in the [media-stack README](media-stack/README.md).

### Tools Stack
Located in `tools/`, this stack contains utility services such as:
- StirlingPDF - PDF manipulation tool

## Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- Git for version control
- Adequate storage space for media content
- Basic understanding of containerization

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd homelab
```

2. Configure environment variables:
```bash
cp media-stack/.env.example media-stack/.env
# Edit the .env file with your settings
```

3. Start desired stack:
```bash
cd <stack-directory>
docker-compose up -d
```

### Basic Usage

Each stack can be managed independently using Docker Compose commands:

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Update containers
docker-compose pull
docker-compose up -d
```

For specific setup and usage instructions for each stack, refer to their respective README files:
- [Media Stack Documentation](media-stack/README.md)
