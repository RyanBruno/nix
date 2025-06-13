#!/usr/bin/env bash
HOSTNAME=$(hostname)
sudo nixos-rebuild switch --flake ./nixos#$HOSTNAME