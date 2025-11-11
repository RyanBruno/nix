sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
    --dry-run \
    --mode destroy,format,mount \
    ./nixos/disko/ssd.nix