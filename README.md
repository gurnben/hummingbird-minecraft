# Hummingbird Minecraft Server

A Minecraft server container that downloads server.jar from the Microsoft Mojang source and runs on Fedora Project Hummingbird-based images via Podman.

## Build

```bash
podman build -t hummingbird-minecraft:latest -f Containerfile
```

## Run

```bash
podman run --replace --name minecraft-server \
  -v $(pwd)/server_files:/server_files:Z,U \
  -p 25565:25565 \
  ghcr.io/pshickeydev/hummingbird-minecraft:latest
```

This runs the server with all persistent data (world, configs, etc.) stored in the local `server_files/` directory.

## Upgrading

```bash
podman rm -f minecraft-server && podman run --replace --name minecraft-server \
  -v $(pwd)/server_files:/server_files:Z,U \
  -p 25565:25565 \
  ghcr.io/pshickeydev/hummingbird-minecraft:latest
```

Your world and configuration are preserved since they live on the host in `./server_files/`.
