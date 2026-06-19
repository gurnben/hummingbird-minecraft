# NOTES

## Personal Notes

- It can be easy to fall into the "one more game" type of mentality because starting the prompt is easier than the verification at the end. Find good stopping points for a healthy balance.
- Workflow of telling the agent to create a TODO list then work through the items sequentially helped avoid spiraling, but not always. Instructions to work in small, discrete steps showed additional improvement, but still was no guarantee of consistent work process.
- Models were likely trained based on container workflow which were not specific to distroless images. This caused many failed attempts to use alternative ENTRYPOINT or RUN syntax which would rely upon `/bin/sh`. These commands fail in distroless images so we need to provide full explicit paths to the binaries which are present in order to make otherwise simple things work.
  - Turns out there are [Hummingbird AI Skills](https://gitlab.com/redhat/hummingbird/skills) which probably could have helped with this. Definitely should have looked into that earlier.

## Generated Notes

### Architecture Notes

- The verify CI step (build, run for 60s, grep output) provides a simple but effective integration test for container images. The expected string should be something guaranteed to appear in normal startup output.

- Multi-stage builds with build-time downloads keep the final image self-contained. The `:Z,U` volume mount options are necessary for SELinux-enabled systems but should be removed on non-SELinux hosts.

- Chainguard STS (OIDC-based short-lived tokens, defined in `.github/chainguard/`) eliminates long-lived secret management. Each workflow's STS YAML specifies the minimal permissions needed.

- Scheduling automated version checks on Tuesday/Wednesday afternoons UTC prevents PR flooding while keeping the image reasonably current.

- JVM G1GC tuning is critical for game server performance. On a 4GB host, 2GB heap and 512MB metaspace leave sufficient headroom for the OS and native allocations.

- Base image verification via the Hummingbird API (`https://api-hummingbird.hummingbird-project.io/v1/images/{name}/tags` and `https://api-hummingbird.hummingbird-project.io/v1/images/{name}/vulnerabilities/{tag}`) confirms pinned digests are current and CVE-free. Renovate automates digest updates.

- The `runtime` variant is preferred over `default` for Java final stages — it's a headless JRE (~100MB vs ~120MB) with no compiler or desktop dependencies.

