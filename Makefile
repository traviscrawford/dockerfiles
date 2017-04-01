run:
	SSH_AUTH_SOCK=$(echo $SSH_AUTH_SOCK)
	docker run --rm -it \
		-v ~/src:/workspace \
		-v local_maven_cache:/root/.m2/repository \
		-v pants_ivy_cache:/root/.ivy2/pants \
		-v ~/.cache/pants:/root/.cache/pants \
		-v ~/.gitconfig:/root/.gitconfig \
		-v ~/.ssh/known_hosts:/root/.ssh/known_hosts \
		-v $(SSH_AUTH_SOCK):/var/run/ssh.sock \
		-e SSH_AUTH_SOCK=/var/run/ssh.sock \
		dev bash

volume:
	docker volume create --name local_maven_cache
	docker volume create --name pants_ivy_cache

build:
	docker build --tag dev .

