# SrCidadão - Coletor de dados da Câmara dos Deputados

Biblioteca para Download de XMLs dos Serviços de Dados Abertos da Câmara dos Deputados e Processamento dos XMLspara um banco de Dados MySQL.

# Pré requisitos

  - Servidor MySql 5.6 ou superior.
  - PHP 7 ou superior.
  - Servidor Apache 2.2 ou Superior.

## Onde começar

### Via composer

Adicione SrCidadão ao composer.json.
```
$ composer require wagner-goncalves/srcidadao-coletor-camara
```

E atualize o composer
```
$ composer update
```

# Instalação

  - Criar banco de dados "srcidadao", disponível [aqui](https://github.com/wagner-goncalves/srcidadao-coletor-camara/blob/master/db/camara.sql). 
  - Configurar conexão com o banco de dados e a pasta onde os arquivos XML serão baixados no arquivo /src/Camara/Config/.config.
  - Conceder permissão de escrita para a pasta configurada anteriormente para receber os XMLs baixados.
  - Configurar eventuais exceções de firewall, uma vez que a biblioteca conecta-se no site remoto da Câmara dos Deputados.

# Como usar

### Download e processamento de dados

Inicialização

```php
// Se instalado via composer, use este código para incluir autoloader no topo do projeto.
require 'vendor/autoload.php';

// SrCidadão namespace
use SrCidadao\Coletor\Camara\Downloader;
use SrCidadao\Coletor\Camara\Processor;

//Recupera variáveis de configuração
$dotenv = new Dotenv\Dotenv(__DIR__ . "/../src/Camara/Config/", ".config");
$dotenv->load();

//Codigo sequencial. Deve ser gerado na tabela camara_processamento
$codProcessamento = 1; 

$downloader = new Downloader($codProcessamento); // Passo 1, download da XMLs
$processor = new Processor($codProcessamento); // Passo 2, processa XML para banco de dados
```

Partidos políticos
```php
$result = $downloader->obterPartidosCD(); //Obtém lista de partidos ativos
$result = $processor->obterPartidosCD(); //Processa para a tabela camara_partido  
```
Deputados
```php
$result = $downloader->obterDeputados(); //Obtém lista de deputados ativos
$result = $processor->obterDeputados(); //Processa para a tabela camara_deputado  
```
Presença dos deputados
```php
$result = $downloader->listarPresencasDia("20/09/2018", "30/09/2018"); //Obtém arquivos de presença em prenário (um XML por dia)
$result = $processor->listarPresencasDia("20/09/2018", "30/09/2018"); //Processa para a lista de presença para a tabela camara_presenca 
```
Proposições colocadas em votação no plenário
```php
$result = $downloader->listarProposicoesVotadasEmPlenario(2017, 2018); //Obtém proposições (resumo) votadas em prenário (um XML por ano)
$result = $processor->listarProposicoesVotadasEmPlenario(2017, 2018); //Processa para a lista de proposições para a tabela camara_proposicaoplenario 
```
Detalhes de proposições
```php
$result = $downloader->obterProposicaoPorID("20/09/2018", "30/09/2018"); //Obtém detalhes de proposições votadas entre dataInicial e dataFinal
$result = $processor->obterProposicaoPorID("20/09/2018", "30/09/2018"); //Processa detalhes de proposições para a tabela camara_proposicao
```
Votação de cada deputado nas proposições
```php
$result = $downloader->obterVotacaoProposicao("20/09/2018", "30/09/2018"); //Obtém votação de cada deputado de proposições votadas entre dataInicial e dataFinal
$result = $processor->obterVotacaoProposicao("20/09/2018", "30/09/2018"); //Processa votos de cada deputado naproposição para a tabela camara_votacaoproposicao
```
Consulte classes de teste em /tests/DownloaderTest.php

Licença
----
LGPL-3.0
