{ pkgs, lib, config, ... }: {

  options = {
    postgres.enable = 
      lib.mkEnableOption "enables postgres";
  };

  config = lib.mkIf config.postgres.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "tin" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  user  auth-method options
        local all       all   peer        map=superuser_map
      '';
      identMap = ''
        # ArbitraryMapName systemUser DBUser
          superuser_map     root      postgres
          superuser_map     ryan      postgres
          superuser_map     postgres  postgres
      '';
    };
  };
}