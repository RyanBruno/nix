{ pkgs, lib, config, inputs, ... }: {

  options = {
    home-manager.enable = 
      lib.mkEnableOption "enables Ryan's home-manager";
  };

  config = lib.mkIf config.home-manager.enable {
    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "ryan" = import ../homes/ryan.nix;
      };
    };
  };
}
