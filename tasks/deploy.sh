nixos-rebuild switch --flake ./nixos#thorax \
  --target-host ryan@10.173.174.143 \
  --build-host ryan@10.173.174.143 \
  --use-remote-sudo --ask-sudo-password