#!/usr/bin/env bash
set -x -e
sudo dnf -y install \
	bats
sudo npm install -g htmlhint
