
{ pkgs, lib, config, ... }: {

  options = {
    homepage.enable = 
      lib.mkEnableOption "enables my homepage";
  };

  config = lib.mkIf config.homepage.enable {
    # homepage-dashboard
    services.homepage-dashboard = {
        # These options were already present in my configuration.
        enable = true;
        listenPort = 8082;
        # https://gethomepage.dev/latest/configs/settings/
        settings = {
            title = "Hello world";
            color = "slate";
        };
        # https://gethomepage.dev/latest/configs/bookmarks/
        bookmarks = [
        {
            Developer = [
            {
                Github = [
                {
                    abbr = "GH";
                    href = "https://github.com/";
                }
                ];
            }
            ];
        }
        {
            Entertainment = [
            {
                YouTube = [
                {
                    abbr = "YT";
                    href = "https://youtube.com/";
                }
                ];
            }
            ];
        }
        ];
        # https://gethomepage.dev/latest/configs/services/
        services = [
        {
            "Self Hosted" = [
            {
                "Home Assistant" = {
                description = "IoT Automation";
                href = "https://ishtar.tail3be192.ts.net/homeassistant/";
                };
            }
            {
                "Bitwarden" = {
                description = "Password Manager";
                href = "https://ishtar.tail3be192.ts.net/vaultwarden/";
                };
            }
            {
                "Vaultwarden Admin" = {
                description = "Administration Page for Vaultwarden (password)";
                href = "https://ishtar.tail3be192.ts.net/vaultwarden/admin/";
                };
            }
            {
                "Shiori" = {
                description = "Bookmark Manager (shiori/gopher)";
                href = "https://ishtar.tail3be192.ts.net/bookmarks";
                };
            }
            {
                "NextCloud" = {
                description = "Cloud Collaboration (root/password4321)";
                href = "http://ishtar.tail3be192.ts.net/";
                };
            }
            ];
        }
        ];
        # https://gethomepage.dev/latest/configs/service-widgets/
        widgets = [
        {
            resources = {
            cpu = true;
            disk = "/";
            memory = true;
            };
        }
        {
            search = {
            provider = "duckduckgo";
            target = "_blank";
            };
        }
        ];
        # https://gethomepage.dev/latest/configs/kubernetes/
        kubernetes = { };
        # https://gethomepage.dev/latest/configs/docker/
        docker = { };
        # https://gethomepage.dev/latest/configs/custom-css-js/
        customJS = "";
        customCSS = "";
    };

    services.nginx = {
        #user = "root";
        enable = true;
        virtualHosts = {
            "ishtar.tail3be192.ts.net" = {
                #forceSSL = true;
                #sslCertificate = "/var/lib/tailscale/certs/ishtar.tail3be192.ts.net.crt";
                #sslCertificateKey = "/var/lib/tailscale/certs/ishtar.tail3be192.ts.net.key";
                locations = {
                    "/" = {
                        proxyPass = "http://127.0.0.1:8082/";
                    };
                    "/vaultwarden/" = {
                        proxyPass = "http://127.0.0.1:8222/";
                    };
                    "/bookmarks/" = {
                        proxyPass = "http://127.0.0.1:8080/";
                    };
                    "/homeassistant/" = {
                        proxyPass = "http://127.0.0.1:8123/";
                    };
                };
            };
        };
    };
  };
}