#!/usr/bin/env bash
sudo nix-collect-garbage -d
sudo nix-store --gc
