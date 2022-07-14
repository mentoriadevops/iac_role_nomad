#!/usr/bin/env bash

nomad_config_path=/etc/nomad.d

help() {
  echo "
uso: nomad_boostrap.sh [-h|--help] mode [bootstrap_expect] [rety_join] [region] [datacenter] [secrets]

Inicializa os arquivos de configuração do Nomad e habilita a unidade do Nomad no systemd.

argumentos:
  mode                   modo em que o Nomad vai rodar. Valores possíveis: server, client ou both.

argumentos opcionais:
  --help, -h, help       imprime essa mensagem de ajuda.
  bootstrap_expect       número de servidores no cluster.
  retry_join             lista de IPs ou configuração do cloud auto-join.
  region                 região do agente Nomad
  datacenter             datacenter do agente Nomad
  secrets                segredos que serão colocados na máquina

exemplos:
  Iniciar cluster local com client e servidor:
    nomad_boostrap.sh both 1

  Iniciar cluster no GCP com cloud auto-join:
    nomad_boostrap.sh server 3 '\"provider=gce project_name=meu-projeto tag_value=nomad-server\"'
    nomad_boostrap.sh client '\"provider=gce project_name=meu-projeto tag_value=nomad-server\"'

  Iniciar cluster configurado com mTLS
    nomad_boostrap.sh server 3 '\"provider=gce project_name=meu-projeto tag_value=nomad-server\"' global dc1 nomad-ca:1 nomad-server-cert:2 nomad-server-key:1
    nomad_boostrap.sh client '\"provider=gce project_name=meu-projeto tag_value=nomad-server\"' global dc1 nomad-ca:1 nomad-client-cert:2 nomad-client-key:1
"
}

main() {
  local mode="$1"

  case "${mode}" in
    server)
      render_server_config "${@:2}"
      ;;
    client)
      render_client_config "${@:2}"
      ;;
    both)
      render_both_config "${@:2}"
      ;;
    help | --help | -h)
      help
      exit 0
      ;;
    *)
      echo "Parâmetro 'mode' invalido."
      help
      exit 1
      ;;
  esac

  echo "Habilitando e iniciando a unidade do Nomad no systemd..."
  systemctl enable nomad
  systemctl start nomad

  echo "Finalizado."
  exit 0
}

render_server_config() {
  local bootstrap_expect="$1"
  local retry_join="${2:-\"127.0.0.1\"}"
  local region="${3:-global}"
  local datacenter="${4:-dc1}"
  local ca_secret="$5"
  local server_cert_secret="$6"
  local server_key_secret="$7"

  echo "Renderizando arquivo de configuração do server..."

  if [[ -z "${bootstrap_expect}" ]]; then
    echo "Parâmetro 'bootstrap_expect' não informado."
    exit 1
  fi

  sed --expression "
    s/<BOOTSTRAP_EXPECT>/${bootstrap_expect}/
    s/<RETRY_JOIN>/${retry_join}/
    s/<REGION>/${region}/
    s/<DATACENTER>/${datacenter}/
  " "${nomad_config_path}/server.hcl.tpl" > "${nomad_config_path}/server.hcl"

  google_secret "$(echo $ca_secret | cut -d: -f1)" "$(echo $ca_secret | cut -d: -f2)" "/etc/nomad.d/certs/nomad-ca.pem"
  google_secret "$(echo $server_cert_secret | cut -d: -f1)" "$(echo $server_cert_secret | cut -d: -f2)" "/etc/nomad.d/certs/server.pem"
  google_secret "$(echo $server_key_secret | cut -d: -f1)" "$(echo $server_key_secret | cut -d: -f2)" "/etc/nomad.d/certs/server-key.pem"
}

render_client_config() {
  local retry_join="${1:-\"127.0.0.1\"}"
  local region="${2:-global}"
  local datacenter="${3:-dc1}"
  local ca_secret="$4"
  local client_cert_secret="$5"
  local client_key_secret="$6"

  echo "Renderizando arquivo de configuração do client..."

  sed --expression "
    s/<RETRY_JOIN>/${retry_join}/
    s/<REGION>/${region}/
    s/<DATACENTER>/${datacenter}/
  " "${nomad_config_path}/client.hcl.tpl" > "${nomad_config_path}/client.hcl"

  google_secret "$(echo $ca_secret | cut -d: -f1)" "$(echo $ca_secret | cut -d: -f2)" "/etc/nomad.d/certs/nomad-ca.pem"
  google_secret "$(echo $client_cert_secret | cut -d: -f1)" "$(echo $client_cert_secret | cut -d: -f2)" "/etc/nomad.d/certs/client.pem"
  google_secret "$(echo $client_key_secret | cut -d: -f1)" "$(echo $client_key_secret | cut -d: -f2)" "/etc/nomad.d/certs/client-key.pem"
}

render_both_config() {
  local bootstrap_expect="$1"
  local retry_join="${2:-\"127.0.0.1\"}"
  local region="${3:-global}"
  local datacenter="${4:-dc1}"

  render_server_config "${bootstrap_expect}" "${retry_join}" "${region}" "${datacenter}"
  render_client_config "${retry_join}" "${region}" "${datacenter}"
}

google_secret() {
  local secret="$1"
  local version="$2"
  local path="$3"

  gcloud secrets versions access "$version" --secret="$secret" > "$path"
  chmod 400 "$path"
}

main "$@"
