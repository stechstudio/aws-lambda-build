SHELL := /bin/bash
.DEFAULT_GOAL := image

image:
	docker build -t stechstudio/aws-lambda-build:latest .

container: image
	docker run --interactive --tty -v ${PWD}:/export -e "TERM=xterm-256color" stechstudio/aws-lambda-build:latest