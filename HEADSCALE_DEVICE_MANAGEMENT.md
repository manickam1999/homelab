# Headscale Device Management Guide

This guide explains how to manage users and devices in your self-hosted Headscale server.

## Prerequisites

- Headscale server running in Docker (as configured in `core/docker-compose.yml`)
- Access to the server where Headscale is running

## User Management

### Create a New User

```bash
docker exec headscale headscale users create [username]
```

**Example:**
```bash
docker exec headscale headscale users create rajesh
docker exec headscale headscale users create family-member
docker exec headscale headscale users create guest
```

### List All Users

```bash
docker exec headscale headscale users list
```

**Output example:**
```
ID | Name | Username | Email | Created            
1  |      | rajesh   |       | 2025-07-10 12:42:35
2  |      | guest    |       | 2025-07-10 13:15:22
```

### Delete a User

```bash
docker exec headscale headscale users delete [username]
```

**Example:**
```bash
docker exec headscale headscale users delete guest
```

## Device Management

### Add a Device to a User

#### Step 1: Generate Pre-Auth Key

```bash
docker exec headscale headscale preauthkeys create --user [USER_ID] --reusable --expiration 24h
```

**Example:**
```bash
# For user "rajesh" (ID: 1)
docker exec headscale headscale preauthkeys create --user 1 --reusable --expiration 24h
```

**Output:**
```
57665976adac9c057bf66ddc6c71b14e25e790fc57f749e9
```

#### Step 2: Connect Device

On the device you want to connect:

```bash
# For devices with Tailscale installed
sudo tailscale up --login-server http://192.168.100.88:8082 --authkey [AUTH_KEY]

# With custom hostname (recommended)
sudo tailscale up --login-server http://192.168.100.88:8082 --authkey [AUTH_KEY] --hostname [DEVICE_NAME]
```

**Examples:**
```bash
# iPhone (use Tailscale app - enter server URL and auth key)
# Server
sudo tailscale up --login-server http://192.168.100.88:8082 --authkey 57665976adac9c057bf66ddc6c71b14e25e790fc57f749e9 --hostname homelab-server

# Laptop
sudo tailscale up --login-server http://192.168.100.88:8082 --authkey 57665976adac9c057bf66ddc6c71b14e25e790fc57f749e9 --hostname rajesh-laptop

# Android (use Tailscale app - enter server URL and auth key)
```

### Alternative: Manual Device Registration

If you don't have a pre-auth key:

1. **Start Tailscale without auth key:**
```bash
sudo tailscale up --login-server http://192.168.100.88:8082
```

2. **Get the device key from the output and register manually:**
```bash
docker exec headscale headscaregister --user [USERNAME] --key [DEVICE_KEY]
```

**Example:**
```bash
docker exec headscale headscale nodes register --user rajesh --key HaKvY4_scCCdknBLqD_cGqV9
```

### List All Devices

```bash
docker exec headscale headscale nodes list
```

**Output example:**
```
ID | Hostname      | Name          | User   | IP addresses                  | Connected | Last seen          
1  | localhost     | localhost     | rajesh | 100.64.0.2, fd7a:115c:a1e0::2| online   | 2025-07-10 13:01:01
2  | homelab-server| homelab-server| rajesh | 100.64.0.3, fd7a:115c:a1e0::3| online   | 2025-07-10 13:01:00
3  | rajesh-laptop | rajesh-laptop | rajesh | 100.64.0.4, fd7a:115c:a1e0::4| online   | 2025-07-10 14:30:15
```

### Check Devices for a Specific User

```bash
docker exec headscale headscale nodes list --user [USERNAME]
```

**Example:**
```bash
docker exec headscale headscale nodes list --user rajesh
```

### Remove a Device

```bash
docker exec headscale headscale nodes delete [NODE_ID]
```

**Example:**
```bash
docker exec headscale headscale nodes delete 3
```

## Pre-Auth Key Management

### Create Pre-Auth Keys

```bash
# Basic key (1 hour expiration)
docker exec headscale headscale preauthkeys create --user [USER_ID]

# Reusable key (24 hours)
docker exec headscale headscale preauthkeys create --user [USER_ID] --reusable --expiration 24h

# Long-term key (30 days)
docker exec headscale headscale preauthkeys create --user [USER_ID] --reusable --expiration 720h
```

### List Pre-Auth Keys

```bash
docker exec headscale headscale preauthkeys list
```

### Delete Pre-Auth Key

```bash
docker exec headscale headscale preauthkeys delete [KEY_ID]
```

## Device Organization Best Practices

### Naming Convention

Use descriptive hostnames when connecting devices:

```bash
# Format: [user]-[device-type]-[optional-identifier]
--hostname rajesh-iphone
--hostname rajesh-laptop-work
--hostname rajesh-desktop-gaming
--hostname rajesh-server-homelab
--hostname guest-phone
```

### User Organization Strategies

#### Option 1: One User per Person (Recommended)
```bash
docker exec headscale headscale users create rajesh
docker exec headscale headscale users create spouse
docker exec headscale headscale users create kids
```

#### Option 2: Users by Device Type
```bash
docker exec headscale headscale users create mobile-devices
docker exec headscale headscale users create servers
docker exec headscale headscale users create laptops
```

#### Option 3: Users by Access Level
```bash
docker exec headscale headscale users create admin
docker exec headscale headscale users create family
docker exec headscale headscale users create guests
```

## Accessing Services

Once devices are connected, access homelab services using Tailscale IPs:

### Current Network (Example)
- **Server**: `100.64.0.3` (homelab-server)
- **iPhone**: `100.64.0.2` (rajesh-iphone)

### Service Access URLs
- **Jellyfin**: `http://100.64.0.3:8096`
- **Sonarr**: `http://100.64.0.3:8989`
- **Radarr**: `http://100.64.0.3:7878`
- **qBittorrent**: `http://100.64.0.3:8080`
- **Homepage**: `http://100.64.0.3:3000`
- **Headscale Admin**: `http://100.64.0.3:8082`

## Troubleshooting

### Check Headscale Status
```bash
docker ps | grep headscale
docker logs headscale
```

### Check Tailscale Status on Device
```bash
sudo tailscale status
sudo tailscale ping 100.64.0.3
```

### Restart Headscale
```bash
docker restart headscale
```

### Reset Device Connection
```bash
# On the device
sudo tailscale down
sudo tailscale up --login-server http://192.168.100.88:8082 --authkey [NEW_KEY]
```

## Security Notes

- Pre-auth keys should be kept secure and have reasonable expiration times
- Use the `--ephemeral` flag for temporary devices
- Regularly audit connected devices with `headscale nodes list`
- Remove unused devices and expired keys
- Consider using different users for different access levels

## Quick Reference

```bash
# User management
docker exec headscale headscale users create [username]
docker exec headscale headscale users list
docker exec headscale headscale users delete [username]

# Device management
docker exec headscale headscale nodes list
docker exec headscale headscale nodes delete [node-id]
docker exec headscale headscale nodes register --user [username] --key [device-key]

# Pre-auth keys
docker exec headscale headscale preauthkeys create --user [user-id] --reusable --expiration 24h
docker exec headscale headscale preauthkeys list
```