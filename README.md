# Hummingbird Minecraft Server

A Minecraft server container that downloads server.jar from the Microsoft Mojang source and runs on Fedora Project Hummingbird-based images via Podman.

## Build

```bash
podman build -t bird-mc -f Containerfile
```

## Run

```bash
podman run --replace --name minecraft-server \
  -v $(pwd)/server_files:/server_files:Z,U \
  -p 25565:25565 \
  localhost/bird-mc:latest
```

This runs the server with all persistent data (world, configs, etc.) stored in the local `server_files/` directory.

## Upgrading

Rebuild the image and restart:

```bash
podman build -t bird-mc -f Containerfile
podman rm -f minecraft-server && podman run --replace --name minecraft-server \
  -v $(pwd)/server_files:/server_files:Z,U \
  -p 25565:25565 \
  localhost/bird-mc:latest
```

Your world and configuration are preserved since they live on the host in `./server_files/`.
