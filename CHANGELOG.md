# Changelog

Todas as mudanças importantes neste projeto serão documentas neste arquivo.

O formato é baseado no [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto segue o [Versionamento Semântico](https://semver.org/lang/pt-BR/spec/v2.0.0.html).

## [Não publicado]
### Adicionado
- Configuração para telemetry e raft_protocol [[GH-23](https://github.com/mentoriaiac/iac_role_nomad/pull/23)]
- Configuração para region e datacenter [[GH-24](https://github.com/mentoriaiac/iac_role_nomad/pull/24)]

### Modificado
- Atualizando a versão padrão do Nomad para 1.3.1 [[GH-26](https://github.com/mentoriaiac/iac_role_nomad/pull/26)]

### Corrigido
- Criação da pasta para chaves e certificados mTLS [[GH-29](https://github.com/mentoriaiac/iac_role_nomad/pull/29)]

## [0.3.0] - 2021-09-08
### Adicionado
- Usar role de runtime [[GH-15]](https://github.com/mentoriaiac/iac_role_nomad/pull/15)

## [0.2.0] - 2021-09-08
### Adicionado
- Configuração para habilitar o sistema de ACL  [[GH-13](https://github.com/mentoriaiac/iac_role_nomad/pull/13)]

### Corrigido
- Corrigido problemas ao ler atributos do script de bootstrap [[GH-8](https://github.com/mentoriaiac/iac_role_nomad/pull/8)]

## [0.1.0] - 2021-09-04
### Adicionado
- Instalação, configuração e testes do pacote do Nomad [[GH-2](https://github.com/mentoriaiac/iac_role_nomad/pull/2)]
- Instalação dos plugins de CNI [[GH-5](https://github.com/mentoriaiac/iac_role_nomad/pull/5)]
- Script de inicialização da imagem [[GH-6](https://github.com/mentoriaiac/iac_role_nomad/pull/6)]


[Não publicado]: https://github.com/mentoriaiac/iac_role_nomad/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/mentoriaiac/iac_role_nomad/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mentoriaiac/iac_role_nomad/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mentoriaiac/iac_role_nomad/releases/tag/v0.1.0
