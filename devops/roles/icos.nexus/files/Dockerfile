# Default version, docker-compose.yml will specify specific version.
ARG VERSION=2.14.13-01

FROM sonatype/nexus:$VERSION

# These are the default uid/gid of the user, as created by the base nexus image.
# docker-compose will specify the host-specific uid/gid.
ARG UID=200
ARG GID=200

# The base image - correctly! - switches to the nexus user. We'll need to
# switch back in order to modify uid/gid.
USER root
RUN groupmod --gid=$GID nexus
RUN usermod --uid=$UID --gid=$GID nexus

USER nexus
