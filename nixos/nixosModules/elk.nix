{ pkgs, lib, config, ... }:

let
  elkVersion = "9.0.1";  # Replace with desired version
in {
  options.elk.enable = lib.mkEnableOption "Run ELK stack (Elasticsearch, Logstash, Kibana) in Docker";

  config = lib.mkIf config.elk.enable {
    virtualisation.docker.enable = true;

    # Optional: Open ports
    networking.firewall.allowedTCPPorts = [
      5601  # Kibana
      # 9200  # Elasticsearch
      5044  # Logstash (e.g. beats input)
    ];

    systemd.services.docker-create-elk-network = {
      description = "Create ELK Docker network";
      wants = [ "docker.service" ];
      after = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c '${pkgs.docker}/bin/docker network create --driver bridge elk-net || true'
        '';
      };
    };

    systemd.services.elasticsearch = {
      description = "Elasticsearch container";
      after = [ "docker.service" "docker-create-elk-network.service" ];
      requires = [ "docker.service" "docker-create-elk-network.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.docker}/bin/docker run --rm \
            --name elasticsearch \
            -m 2g \
            --network elk-net \
            -e "ELASTIC_PASSWORD=password" \
            -e "discovery.type=single-node" \
            -e "xpack.security.enabled=false" \
            -e "xpack.security.enrollment.enabled=false" \
            docker.elastic.co/elasticsearch/elasticsearch:${elkVersion}
        '';
        ExecStop = "${pkgs.docker}/bin/docker stop elasticsearch";
        Restart = "always";
      };
    };

    systemd.services.kibana = {
      description = "Kibana container";
      after = [ "docker.service" "elasticsearch.service" "docker-create-elk-network.service" ];
      requires = [ "docker.service" "docker-create-elk-network.service" ];

      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.docker}/bin/docker run --rm \
            --name kibana \
            -p 5601:5601 \
            -m 2g \
            --network elk-net \
            -e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" \
            docker.elastic.co/kibana/kibana:${elkVersion}
        '';
        ExecStop = "${pkgs.docker}/bin/docker stop kibana";
        Restart = "always";
      };
    };

    systemd.services.logstash = {
      description = "Logstash container";
      after = [ "docker.service" "elasticsearch.service" "docker-create-elk-network.service" ];
      requires = [ "docker.service" "docker-create-elk-network.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.docker}/bin/docker run --rm \
            --name logstash \
            -p 5044:5044 \
            -m 2g \
            --network elk-net \
            -v /etc/logstash:/usr/share/logstash/pipeline \
            docker.elastic.co/logstash/logstash:${elkVersion}
        '';
        ExecStop = "${pkgs.docker}/bin/docker stop logstash";
        Restart = "always";
      };
    };
  };
}
