import argparse
import fileinput
import sys


def server(bootstrap_expect, retry_join, nomad_path):
    retry_join = retry_join
    render_config(f"{nomad_path}server.hcl.tpl",
                  "<BOOTSTRAP_EXPECT>", bootstrap_expect)
    render_config(f"{nomad_path}server.hcl.tpl", "<RETRY_JOIN>", retry_join)


def client(retry_join, nomad_path):
    retry_join = retry_join
    render_config(f"{nomad_path}client.hcl.tpl", "<RETRY_JOIN>", retry_join)


def both(bootstrap_expect, retry_join, nomad_path):
    retry_join = retry_join
    render_config(f"{nomad_path}server.hcl.tpl",
                  "<BOOTSTRAP_EXPECT>", bootstrap_expect)
    render_config(f"{nomad_path}server.hcl.tpl", "<RETRY_JOIN>", retry_join)
    render_config(f"{nomad_path}client.hcl.tpl", "<RETRY_JOIN>", retry_join)


def render_config(file, searchExp, replaceExp):
    for line in fileinput.input(file, inplace=1):
        line = line.replace(searchExp, str(replaceExp))
        sys.stdout.write(line)


def validate_args(args):
    if (args.mode == "server" or args.mode == "both") and args.bootstrap_expect is None:
        print("Parâmetro 'bootstrap_expect' não informado.")
        return False
    return True


EPILOG = """
Exemplos:
    Iniciar cluster local com client e servidor:
        nomad_boostrap.py both -b 1
                                                
    Iniciar cluster no GCP com cloud auto-join:
        nomad_bootstrap.py server  -b 3 -r "provider=gce project_name=meu-projeto tag_value=nomad-server"
        nomad_bootstrap.py client -r "provider=gce project_name=meu-projeto tag_value=nomad-server"
"""

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter, epilog=EPILOG)

    parser.add_argument('mode', help='Modo de execução do nomad', choices=[
                        'server', 'client', 'both'])
    parser.add_argument('--bootstrap-expect', '-b',
                    help='Número de nodes do servidor a aguardar antes de inicializar', type=int)
    parser.add_argument('--retry-join', '-r', help='',
                        type=str, default='127.0.0.1')
    parser.add_argument('--nomad_path', help='Caminho do nomad',
                        type=str, default='/etc/nomad.d/')
    args = parser.parse_args()

    if not validate_args(args):
        sys.exit(1)

    if args.mode == 'server':

        server(args.bootstrap_expect, f'"{args.retry_join}"', args.nomad_path)
    elif args.mode == 'client':
        client(f'"{args.retry_join}"', args.nomad_path)
    else:
        both(args.bootstrap_expect, f'"{args.retry_join}"', args.nomad_path)
