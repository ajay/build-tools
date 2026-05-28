#!/usr/bin/env bash
set -x -e
sudo dnf -y install \
	bats \
	npm
sudo npm install -g \
	htmlhint \
	prettier
