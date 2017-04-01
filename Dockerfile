# # Docker Developer Environment
#
# To provide a consistent developer environment and avoid the need to install
# numerous and potentially conflicting toolchains, this Dockerfile can be used
# to create a development environment image, and documents a workflow for
# using the image for regular development.
#
# ## Prerequisite: set Docker daemon userns-remap option
#
# NOTE: This setting affects all users of the Docker daemon, and should only
# be used on single user machines (e.g.: developer workstation).
#
# By default, the root user inside a container has the same uid/gid as root
# outside the container. This is problematic in our case because bind mount
# the workspace from our host filesystem into the container. Any files
# created in the workspace from within the container will be owned by root
# outside the container. To avoid this issue we must configure and enable
# `userns-remap` for the Docker daemon.
#
# - Update /etc/subuid to have a travis:1000:1 line. This says map the user
#   travis at uid 1000 with 1 id to map. Multiple entries for the same user
#   are supported, so it your subuid file already has an entry for your user
#   it can stay as-is.
# - Update /etc/subgid same as above.
# - Create /etc/docker/daemon.json adding the following userns-remap option.
#   {"userns-remap": "travis:travis"}
# - Restart docker with "sudo systemctl restart docker.service"
#
# Docker will now map user 0 (root) inside the container to user 1000 (travis)
# outside the container, so files created in the workspace from within the
# container will have the exepcted ownership outside the container.
#
# ## Build the development image:
#
#   docker build --tag dev --file Dockerfile.dev . 
#
# ## Create the Maven cache volume:
#
#   docker volume create --name local_maven_cache
#
# ## Develop in this environment with:
#
# To develop in this environment, simply start the container and execute all
# your build commands from the container. The container is largely transparent
# to the developer because all existing tools (e.g.: IDE's) continue to work
# as expected. The primary change for developers is the need to execute shell
# commands in a terminal attached to the container.
#
#   docker run --rm -it -v ~/src:/workspace -v local_maven_cache:/root/.m2/repository dev bash
#

FROM ubuntu:16.04
RUN apt-get update && \
    apt-get upgrade -y && \
    # Install JDK first to ensure correct version is installed (instead of default-jdk)
    apt-get install -y openjdk-8-jdk-headless && \
    apt-get install -y curl gcc git maven python-dev vim wget && \
    apt-get clean
VOLUME /workspace
WORKDIR /workspace
