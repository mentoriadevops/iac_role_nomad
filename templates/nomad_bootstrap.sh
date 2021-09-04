#!/usr/bin/env bash

nomad_config_path=/etc/nomad.d

help() {
  echo "
uso: nomad_boostrap.sh [-h|--help] mode [bootstrap_expect] [rety_join]

Inicializa os arquivos de configuração do Nomad e habilita a unidade do Nomad no systemd.

argumentos:
  mode                   modo em que o Nomad vai rodar. Valores possíveis: server, client ou both.

argumentos opcionais:
  --help, -h, help       imprime essa mensagem de ajuda.
  bootstrap_expect       número de servidores no cluster.
  retry_join             lista de IPs ou configuração do cloud auto-join.


exemplos:
  Iniciar cluster local com client e servidor:
    nomad_boostrap.sh both 1

  Iniciar cluster no GCP com cloud auto-join:
    nomad_boostrap.sh server 3 '\"provider=gce project_name=meu-projeto tag_value=nomad-server\"'
    nomad_boostrap.sh client '\"provider=gce project_name=meu-projeto tag_value=nomad-server\"'
"
}

main() {
  local mode=$1
  local bootstrap_expect=$2
  local retry_join=${3:-'"127.0.0.1"'}

  case "$mode" in
    server | client | both)
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

  if [[ "${mode}" == "server" ]] || [[ "${mode}" == "both" ]]; then
    render_server_config $bootstrap_expect $retry_join
  fi

  if [[ "${mode}" == "client" ]] || [[ "${mode}" == "both" ]]; then
    render_client_config $retry_join
  fi

  echo "Habilitando e iniciando a unidade do Nomad no systemd..."
  systemctl enable nomad
  systemctl start nomad

  echo "Finalizado."
  exit 0
}

render_server_config() {
  local bootstrap_expect=$1
  local retry_join=$2

  echo "Renderizando arquivo de configuração do server..."

  if [[ -z "${bootstrap_expect}" ]]; then
    echo "Parâmetro 'bootstrap_expect' não informado."
    exit 1
  fi

  sed --expression "
    s/<SERVER_ENABLED>/true/
    s/<BOOTSTRAP_EXPECT>/${bootstrap_expect}/
    s/<RETRY_JOIN>/${retry_join}/
  " ${nomad_config_path}/server.hcl.tpl > ${nomad_config_path}/server.hcl
}

render_client_config() {
  local retry_join=$1

  echo "Renderizando arquivo de configuração do client..."

  sed --expression "
    s/<CLIENT_ENABLED>/true/
    s/<RETRY_JOIN>/${retry_join}/
  " ${nomad_config_path}/client.hcl.tpl > ${nomad_config_path}/client.hcl
}

main $@
