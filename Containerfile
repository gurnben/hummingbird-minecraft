ARG BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
ARG MINECRAFT_VERSION="26.1.2"

# Download latest Minecraft server jar
FROM quay.io/hummingbird/curl:8.20.0@sha256:98b3f40a11815db552fc525884c08f4fcb2c63d372eb402b66632e3ee5640e51 AS downloader
WORKDIR /tmp
RUN ["/usr/bin/curl", "-O", "https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar"]

# Run Minecraft server
FROM quay.io/hummingbird/openjdk:25.0.3-runtime@sha256:1aa412d8d94fa07eccd14a928d4ffd603e52ec948b376e1280c7bef6ab02e7d2
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
LABEL org.opencontainers.image.description="A Minecraft server container that downloads server.jar from the Microsoft Mojang source and runs on Fedora Project Hummingbird-based images"
LABEL org.opencontainers.image.source="https://github.com/pshickeydev/hummingbird-minecraft"
LABEL org.opencontainers.image.documentation="https://github.com/pshickeydev/hummingbird-minecraft"
LABEL org.opencontainers.image.version="${MINECRAFT_VERSION}"
LABEL org.opencontainers.image.licenses="LicenseRef-https://www.redhat.com/en/about/eulas AND LicenseRef-https://minecraft.net/en-us/eula"
LABEL org.opencontainers.image.base.name="quay.io/hummingbird/openjdk:25.0.3-runtime"
LABEL org.opencontainers.image.base.digest="sha256:1aa412d8d94fa07eccd14a928d4ffd603e52ec948b376e1280c7bef6ab02e7d2"
