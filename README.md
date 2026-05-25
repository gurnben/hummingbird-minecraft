# Hummingbird Minecraft Server

A Minecraft server container that downloads server.jar from the Microsoft Mojang source and runs on Fedora Project Hummingbird-based images via Podman.

## Build

```bash
podman build -t hummingbird-minecraft:latest -f Containerfile
```

## Run

```bash
podman run -d --replace --name minecraft-server \
  --memory=3.5g --cpus=1.75 \
  -v $(pwd)/server_files:/server_files:Z,U \
  -p 25565:25565 \
  ghcr.io/pshickeydev/hummingbird-minecraft:latest
```

This runs the server with all persistent data (world, configs, etc.) stored in the local `server_files/` directory. The container is limited to 3.5GB of RAM and 1.75 of the 2 available CPUs, and the JVM is configured with 2GB of heap to leave headroom for the OS and native allocations.

## Upgrading

```bash
podman stop minecraft-server && \
podman rm -f minecraft-server && \
podman rmi -f ghcr.io/pshickeydev/hummingbird-minecraft:latest && \
podman run -d --replace --name minecraft-server \
  --memory=3.5g --cpus=1.75 \
  -v $(pwd)/server_files:/server_files:Z,U \
  -p 25565:25565 \
  ghcr.io/pshickeydev/hummingbird-minecraft:latest
```

Your world and configuration are preserved since they live on the host in `./server_files/`.
