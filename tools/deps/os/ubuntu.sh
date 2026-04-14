#!/usr/bin/env bash
set -x -e
sudo apt -y install \
	bats
sudo npm install -g \
	htmlhint \
	prettier
