# Template Role Ansible

![Pipeline Status](https://github.com/mentoriaiac/iac-role-nomad/actions/workflows/ci.yml/badge.svg) 

Esse projeto tem a finalidade de ser uma Role Ansible para instalar o Nomad.

## Dependências

Para realizar os teste localmente é necessário a instalação das seguintes dependências:

    Python
    Molecule

## Preparando o ambiente

### Primeiro Passo:

Clone este repositório, ele é a base da role do nomad.
> git clone https://github.com/mentoria/iac-role-nomad


Ao final um diretório com a sua role será criado e você precisa agora entrar neste novo diretório. Para fazer isto use o comando a seguir:
> cd iac-role-nomad


### Segundo Passo
Crie um ambiente virtual para o python3. Como o ansible e o molecule são escritos em python, vamos precisar muito de uma estrutura de isolamento, como é o caso do modulo venv do python. Para criar um ambiente python isolado use o comando a seguir:

> python3 -m venv o-nome-da-sua-env


Você pode colocar o nome que você desejar para seu ambiente virtual, contudo existe uma convenção que estimula você usar este padrão: venv, .venv, env, .env

Uma vez criado seu ambiente virtual, precisamos inicializá-lo, para tal, execute o comando a seguir:

> source o-nome-da-sua-env/bin/activate


Se tudo der certo, seu pronpt será modificado e iniciará aparentemente assim:

> (o-nome-da-sua-env)$


Uma vez criado e inicializado o seu ambiente precisamos instalar todas as dependências necessárias para tudo acontecer certinho. As dependências desta role está gravada no arquivo ***requirements.txt***. Para instalar as dependências use o comando a seguir:

> (o-nome-da-sua-env)$ python3 -m pip install -r requirements.txt


### Terceiro Passo
Para verificar se tudo aconteceu bem, você pode executar o comando a seguir:

> (o-nome-da-sua-env)$ molecule check


Ele ira executar um ciclo interiro de testes (dependency, cleanup, destroy, create, prepare, converge, check, cleanup, destroy)

### Quarto Passo
Para realizar teste rápido após alguma modificação execute a seguinte sequência de comandos:

> (o-nome-da-sua-env)$ molecule create

> (o-nome-da-sua-env)$ molecule converge

> (o-nome-da-sua-env)$ molecule verify


Ao termino do teste, destrua o ambiente

> (o-nome-da-sua-env)$ molecule destroy


> (o-nome-da-sua-env)$ molecule check


Para realizar teste rápido após alguma modificação

> (o-nome-da-sua-env)$ molecule create

> (o-nome-da-sua-env)$ molecule converge

> (o-nome-da-sua-env)$ molecule verify


Ao termino do teste, destrua o ambiente

> (o-nome-da-sua-env)$ molecule destroy
