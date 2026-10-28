# docker-compose for air/OS

air/OS (Haiku) port of Docker Compose, maintained by the airos-works
project. Upstream is [docker/compose](https://github.com/docker/compose).
Port changes stay in this fork (upstream's AI/contribution policy does not
accept them), following the same conventions as the airos-works docker,
moby and containerd forks.

## Status

- Builds for `haiku/amd64` and `haiku/arm64` (`tools/build-haiku.sh`).
- The binary is a Docker CLI client: it drives the Engine (airos-works/moby)
  over the API socket, so it works wherever the ported CLI does. It installs
  as both `docker-compose` and a CLI plugin (`lib/docker/cli-plugins/`), so
  `docker compose` works out of the box.
- Port changes: the shared x/sys/unix Haiku shim, logrus terminal check,
  moby/sys/user + gofrs/flock + cni build tags, ino_t casts, containerd
  content-store atime, secrets-engine socket path (filesystem socket instead
  of the Linux abstract namespace), compose's runtime/cache dirs, and a
  fsnotify stub (BFS node monitoring is the future backend; `compose
  up --watch` does not deliver file events in this stage).

## Building

```sh
tools/build-haiku.sh                 # build/haiku-{amd64,arm64}/docker-compose
tools/package-haiku-cross.sh         # artifacts/docker_compose-*.hpkg
```
