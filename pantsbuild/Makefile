# NOTE: Please see the setup instructions in `../Dockerfile` for how to
# configure uid mapping between the container and your local filesystem.

run:
	# :z suffix is needed to work with selinux
	# https://stackoverflow.com/questions/24288616/permission-denied-on-accessing-host-directory-in-docker
	docker run --rm -it \
		-v ~/src:/workspace:z \
		-v cache_pants:/root/.cache/pants \
		pantsbuild bash

volume:
	docker volume create --name cache_pants

build:
	docker build --tag pantsbuild ~/src/pants/build-support/docker/centos6

