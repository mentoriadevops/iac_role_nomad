Template Role Ansible

Esse projeto tem a finalidade de ser um template para futuras criações de projetos que usem ansible e molecule (para teste do playbook).
Dependências

Para realizar os teste localmente é necessário a instalação das seguintes dependências:

    Python
    Molecule

Preparando o ambiente

Crie um ambiente python

$ python3 -m venv .venv

Ative o ambiente

$ source .venv/bin/active

Instale dentro do ambiente o molecule (e suas dependencias) e o pytest-testinfra
```
Para construir o ambiente python e instalar todas as dependencias necessárias para executar esta role use o arquivo de dependências 'requirements.txt' como mostrado a baixo. 
```
(venv)$ python3 -m pip install - r requirements.txt

Executando todos os processo (Destroy, Create, Test, Converge, Verify)

(venv)$ molecule check

Para realizar teste rápido após alguma modificação

(venv)$ molecule create
(venv)$ molecule converge
(venv)$ molecule verify

Ao termino do teste, destrua o ambiente

(venv)$ molecule destroy
