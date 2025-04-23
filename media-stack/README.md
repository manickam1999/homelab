# Homelab

This repository contains the complete configuration for my home server infrastructure, organized as a collection of specialized Docker-based stacks.

## Structure

```
homelab/
├── media-stack/     # Media server and automation
├── core/           # Core infrastructure services
└── [future-stacks] # Additional stacks as needed
```

## Stacks

### Media Stack
A comprehensive media server solution including:
- Jellyfin (Media Server)
- Sonarr (TV Shows)
- Radarr (Movies)
- Prowlarr (Indexer)
- Jackett (Additional Indexer)
- qBittorrent (Download Client)
- Jellyseerr (Request Management)
- Suggestarr (Media Suggestions)

See [media-stack/README.md](media-stack/README.md) for detailed setup instructions.

### Core (Planned)
Core infrastructure services will be managed here.

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd homelab
```

2. Set up environment files:
```bash
cp .env.example .env
```

3. Configure individual stacks:
- Follow the README.md in each stack directory for specific setup instructions
- Each stack may have its own environment variables and configuration requirements

4. Start services:
- Navigate to the desired stack directory
- Follow stack-specific startup instructions

## Global Configuration

- Common environment variables are stored in the root `.env` file
- Stack-specific variables are stored in their respective directories
- Sensitive data and media files are excluded from version control

## Adding New Stacks

1. Create a new directory for your stack
2. Include:
   - docker-compose.yml
   - README.md with setup instructions
   - .env.example for required variables
   - Any necessary configuration files

## Maintenance

### Updates

Each stack can be updated independently:
```bash
cd [stack-directory]
docker-compose pull
docker-compose up -d
```

### Backups

Important directories to backup:
- ./*/config/ (contains all application settings)
- .env files (contains environment configurations)

## Security

- Change default passwords immediately
- Keep API keys and credentials secure
- Never expose services directly to the internet without proper security measures
- Use strong passwords for all services
- Regularly update containers and configurations

## License

This project is open source and available under the MIT License.
