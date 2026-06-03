ARG BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
ARG MINECRAFT_VERSION="26.1.2"

# Download latest Minecraft server jar
FROM registry.access.redhat.com/hi/curl:8.20.0@sha256:3af1f63c3d3a18dc067c781bdb092f4f59ab7d1677a05fbb56aaae96672278e2 AS downloader
WORKDIR /tmp
RUN ["/usr/bin/curl", "-O", "https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar"]

# Run Minecraft server
FROM registry.access.redhat.com/hi/openjdk:25.0.3-runtime@sha256:0987bc710fc1789b2d590e30c097fb50e9bfb372271cd45b804939b7d696a8dc
USER 65532
COPY --from=downloader --chown=65532:65532 /tmp/server.jar /app/server.jar
WORKDIR /server_files
ENTRYPOINT ["/usr/bin/java", \
  "-Xmx2G", "-Xms2G", "-Xmn512M", \
  "-XX:+UseG1GC", \
  "-XX:+UnlockExperimentalVMOptions", \
  "-XX:MaxGCPauseMillis=200", \
  "-XX:G1HeapRegionSize=16M", \
  "-XX:InitiatingHeapOccupancyPercent=45", \
  "-XX:ParallelGCThreads=2", \
  "-XX:ConcGCThreads=1", \
  "-XX:MetaspaceSize=256M", \
  "-XX:MaxMetaspaceSize=512M", \
  "-XX:+AlwaysPreTouch", \
  "-XX:+UseNUMA", \
  "-XX:+DisableExplicitGC", \
  "-XX:+HeapDumpOnOutOfMemoryError", \
  "-XX:HeapDumpPath=/server_files/", \
  "-Djava.net.preferIPv4Stack=true", \
  "-jar", "/app/server.jar", "--nogui"]
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.authors="Patrick Hickey"
LABEL org.opencontainers.image.title="Hummingbird Minecraft Server"
LABEL org.opencontainers.image.description="A Minecraft server container that downloads server.jar from the Microsoft Mojang source and runs on Project Hummingbird images"
LABEL org.opencontainers.image.source="https://github.com/pshickeydev/hummingbird-minecraft"
LABEL org.opencontainers.image.documentation="https://github.com/pshickeydev/hummingbird-minecraft"
LABEL org.opencontainers.image.version="${MINECRAFT_VERSION}"
LABEL com.minecraft.license_terms="https://minecraft.net/en-us/eula"
