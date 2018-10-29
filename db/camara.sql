/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.5.5-10.1.10-MariaDB-log : Database - srcidadao
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`srcidadao` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `srcidadao`;

/*Table structure for table `camara_deputado` */

DROP TABLE IF EXISTS `camara_deputado`;

CREATE TABLE `camara_deputado` (
  `ideCadastro` int(11) NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `codOrcamento` int(11) DEFAULT NULL,
  `condicao` varchar(255) NOT NULL,
  `matricula` int(11) NOT NULL,
  `idParlamentar` int(11) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `nomeParlamentar` varchar(255) DEFAULT NULL,
  `urlFoto` varchar(255) DEFAULT NULL,
  `sexo` set('masculino','feminino') DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  `partido` char(10) NOT NULL,
  `gabinete` int(11) NOT NULL,
  `anexo` int(11) NOT NULL,
  `fone` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`ideCadastro`),
  KEY `fk_camara_deputado_camara_processamento1_idx` (`codProcessamento`),
  KEY `fk_camara_deputado_camara_partido1_idx` (`partido`),
  CONSTRAINT `fk_camara_deputado_camara_partido1` FOREIGN KEY (`partido`) REFERENCES `camara_partido` (`idPartido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_camara_deputado_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_partido` */

DROP TABLE IF EXISTS `camara_partido`;

CREATE TABLE `camara_partido` (
  `idPartido` char(10) NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `siglaPartido` varchar(255) NOT NULL,
  `nomePartido` varchar(255) NOT NULL,
  `dataCriacao` date DEFAULT NULL,
  `dataExtincao` date DEFAULT NULL,
  PRIMARY KEY (`idPartido`),
  KEY `fk_camara_partido_camara_processamento1_idx` (`codProcessamento`),
  KEY `ix_partido_siglapartido` (`siglaPartido`),
  CONSTRAINT `fk_camara_partido_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_presenca` */

DROP TABLE IF EXISTS `camara_presenca`;

CREATE TABLE `camara_presenca` (
  `ideCadastro` int(11) NOT NULL,
  `data` date NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `qtdeSessoesDia` int(11) NOT NULL,
  `legislatura` int(11) DEFAULT NULL,
  `carteiraParlamentar` int(11) DEFAULT NULL,
  `nomeParlamentar` varchar(255) DEFAULT NULL,
  `siglaPartido` char(10) NOT NULL,
  `siglaUF` char(2) NOT NULL,
  `descricaoFrequenciaDia` varchar(255) DEFAULT NULL,
  `justificativa` varchar(255) DEFAULT NULL,
  `presencaExterna` varchar(255) DEFAULT NULL,
  `dataHoraProcessamento` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`data`,`ideCadastro`),
  KEY `fk_presenca_camara_processamento1_idx` (`codProcessamento`),
  KEY `ix_data` (`dataHoraProcessamento`),
  KEY `ix_ideCadastro_presenca` (`ideCadastro`),
  CONSTRAINT `fk_presenca_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_processamento` */

DROP TABLE IF EXISTS `camara_processamento`;

CREATE TABLE `camara_processamento` (
  `codProcessamento` int(11) NOT NULL AUTO_INCREMENT,
  `dataHora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `flgTipo` set('download','processamento','notificacao') DEFAULT NULL,
  `dataHoraFim` timestamp NULL DEFAULT NULL,
  `flgConcluido` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`codProcessamento`)
) ENGINE=InnoDB AUTO_INCREMENT=935 DEFAULT CHARSET=utf8;

/*Table structure for table `camara_processamentoarquivo` */

DROP TABLE IF EXISTS `camara_processamentoarquivo`;

CREATE TABLE `camara_processamentoarquivo` (
  `oid_camara_processamentoarquivo` int(11) NOT NULL AUTO_INCREMENT,
  `arquivo` varchar(500) NOT NULL,
  `flgSucesso` tinyint(4) NOT NULL,
  `dataHora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`oid_camara_processamentoarquivo`)
) ENGINE=InnoDB AUTO_INCREMENT=831 DEFAULT CHARSET=utf8;

/*Table structure for table `camara_proposicao` */

DROP TABLE IF EXISTS `camara_proposicao`;

CREATE TABLE `camara_proposicao` (
  `tipo` char(10) NOT NULL,
  `numero` int(11) NOT NULL,
  `ano` int(11) NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `nomeProposicao` varchar(255) DEFAULT NULL,
  `idProposicao` int(11) DEFAULT NULL,
  `idProposicaoPrincipal` int(11) DEFAULT NULL,
  `nomeProposicaoOrigem` varchar(255) DEFAULT NULL,
  `tipoProposicao` varchar(255) DEFAULT NULL,
  `tema` varchar(255) DEFAULT NULL,
  `Ementa` text,
  `ExplicacaoEmenta` text,
  `Autor` varchar(255) DEFAULT NULL,
  `ideCadastro` int(11) NOT NULL,
  `ufAutor` char(2) NOT NULL,
  `partidoAutor` char(10) NOT NULL,
  `DataApresentacao` date DEFAULT NULL,
  `RegimeTramitacao` varchar(255) DEFAULT NULL,
  `UltimoDespacho` text,
  `Data` date DEFAULT NULL,
  `Apreciacao` text,
  `Indexacao` text,
  `Situacao` varchar(255) DEFAULT NULL,
  `LinkInteiroTeor` varchar(255) DEFAULT NULL,
  `apensadas` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tipo`,`numero`,`ano`),
  KEY `fk_codProcessamento_idx` (`codProcessamento`),
  KEY `ix_idProposicao` (`idProposicao`),
  CONSTRAINT `fk_codProcessamento` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_proposicaoplenario` */

DROP TABLE IF EXISTS `camara_proposicaoplenario`;

CREATE TABLE `camara_proposicaoplenario` (
  `codProposicao` int(11) NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `nomeProposicao` varchar(255) NOT NULL,
  `dataVotacao` date NOT NULL,
  PRIMARY KEY (`codProposicao`,`dataVotacao`),
  KEY `fk_proposicao_camara_processamento1_idx` (`codProcessamento`),
  KEY `ix_dataVotacao` (`dataVotacao`),
  CONSTRAINT `fk_proposicao_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_proposicaoresumo` */

DROP TABLE IF EXISTS `camara_proposicaoresumo`;

CREATE TABLE `camara_proposicaoresumo` (
  `codProcessamento` int(11) DEFAULT NULL,
  `Resumo` text,
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `ObjVotacao` varchar(255) NOT NULL,
  `codSessao` int(11) DEFAULT NULL,
  `Sigla` char(10) NOT NULL,
  `Numero` int(11) NOT NULL,
  `Ano` int(11) NOT NULL,
  PRIMARY KEY (`Numero`,`Sigla`,`ObjVotacao`,`Ano`),
  KEY `fk_codProcessamento_idx` (`codProcessamento`),
  CONSTRAINT `fk_codProcessamento_proposicaoresumo` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_siglastipoproposicao` */

DROP TABLE IF EXISTS `camara_siglastipoproposicao`;

CREATE TABLE `camara_siglastipoproposicao` (
  `tipoSigla` char(10) NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `descricao` varchar(255) NOT NULL,
  `ativa` set('True','False') NOT NULL,
  `genero` set('a','o') NOT NULL,
  PRIMARY KEY (`tipoSigla`),
  KEY `fk_camara_siglastipoproposicao_camara_processamento1_idx` (`codProcessamento`),
  CONSTRAINT `fk_camara_siglastipoproposicao_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_tipoautor` */

DROP TABLE IF EXISTS `camara_tipoautor`;

CREATE TABLE `camara_tipoautor` (
  `id` varchar(255) NOT NULL,
  `codProcessamento` int(11) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_camara_tipoautor_camara_processamento1_idx` (`codProcessamento`),
  CONSTRAINT `fk_camara_tipoautor_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `camara_votacaoproposicao` */

DROP TABLE IF EXISTS `camara_votacaoproposicao`;

CREATE TABLE `camara_votacaoproposicao` (
  `codProcessamento` int(11) DEFAULT NULL,
  `Sigla` char(10) NOT NULL,
  `Numero` int(11) NOT NULL,
  `Ano` int(11) NOT NULL,
  `Nome` varchar(255) DEFAULT NULL,
  `ideCadastro` int(11) NOT NULL,
  `Partido` char(10) NOT NULL,
  `UF` char(2) NOT NULL,
  `Voto` char(10) NOT NULL,
  `ObjVotacao` varchar(255) NOT NULL,
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `codSessao` int(11) DEFAULT NULL,
  PRIMARY KEY (`Sigla`,`Numero`,`Ano`,`ObjVotacao`,`ideCadastro`),
  KEY `fk_camara_proposicao_camara_processamento1_idx` (`codProcessamento`),
  KEY `ix_votacaoproposicao_partido` (`Partido`),
  KEY `ix_ideCadastro_votacao` (`ideCadastro`),
  KEY `ix_ideCadastro_CodProcessamento` (`codProcessamento`,`ideCadastro`),
  CONSTRAINT `fk_camara_proposicao_camara_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Procedure structure for procedure `camaraListarPresencasDia` */

/*!50003 DROP PROCEDURE IF EXISTS  `camaraListarPresencasDia` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `camaraListarPresencasDia`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN

	DECLARE _data VARCHAR(100);
	DECLARE _nomeParlamentar VARCHAR(255);
	DECLARE _carteiraParlamentar INT;
	DECLARE contadorWhile INT DEFAULT 1;
	DECLARE contadorTag INT;
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/dia/parlamentares/parlamentar)');	
	
	-- ALTER TABLE camara_presenca CHANGE COLUMN camara_presenca.data camara_presenca.data CHAR(10) NULL DEFAULT NULL;
	
	WHILE (contadorWhile <= contadorTag) DO 
		SET _data := EXTRACTVALUE(xml, '/dia/data');
		SET _nomeParlamentar := EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/nomeParlamentar');
		SET _carteiraParlamentar := EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/carteiraParlamentar');
		
		INSERT IGNORE INTO camara_presenca (ideCadastro, DATA, codProcessamento, qtdeSessoesDia, 
			legislatura, carteiraParlamentar, nomeParlamentar, siglaPartido, siglaUF, 
			descricaoFrequenciaDia, justificativa, presencaExterna, dataHoraProcessamento)
		SELECT 
			(SELECT camara_deputado.ideCadastro 
				FROM camara_deputado 
				WHERE camara_deputado.matricula = _carteiraParlamentar 
				OR camara_deputado.nomeParlamentar = TRIM(SUBSTRING_INDEX(_nomeParlamentar, '-', 1)) 
				LIMIT 1),
			STR_TO_DATE(TRIM(_data), '%d/%m/%Y'),
			codProcessamento,
			EXTRACTVALUE(xml, '/dia/qtdeSessoesDia'),
			EXTRACTVALUE(xml, '/dia/legislatura'),
			EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/carteiraParlamentar'),
			_nomeParlamentar,
			TRIM(EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/siglaPartido')),
			EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/siglaUF'),
			EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/descricaoFrequenciaDia'),
			EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/justificativa'),
			EXTRACTVALUE(xml, '/dia/parlamentares/parlamentar[$contadorWhile]/presencaExterna'),
			CURRENT_TIMESTAMP;
		SET contadorWhile := contadorWhile + 1;
	END WHILE;
	-- ALTER TABLE camara_presenca CHANGE COLUMN camara_presenca.data camara_presenca.data DATE NULL DEFAULT NULL;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `camaraListarProposicoesVotadasEmPlenario` */

/*!50003 DROP PROCEDURE IF EXISTS  `camaraListarProposicoesVotadasEmPlenario` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `camaraListarProposicoesVotadasEmPlenario`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN
	
	DECLARE contadorWhile INT DEFAULT 1;
	DECLARE contadorTag INT;
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/proposicoes/proposicao)');	
	
	WHILE (contadorWhile <= contadorTag) DO 
		INSERT IGNORE INTO camara_proposicaoplenario (codProposicao, codProcessamento, nomeProposicao, dataVotacao)
		SELECT 
			EXTRACTVALUE(xml, '/proposicoes/proposicao[$contadorWhile]/codProposicao'),
			codProcessamento,
			EXTRACTVALUE(xml, '/proposicoes/proposicao[$contadorWhile]/nomeProposicao'),
			STR_TO_DATE(EXTRACTVALUE(xml, '/proposicoes/proposicao[$contadorWhile]/dataVotacao'), '%d/%m/%Y');
		SET contadorWhile := contadorWhile + 1;
	END WHILE;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `camaraObterDeputados` */

/*!50003 DROP PROCEDURE IF EXISTS  `camaraObterDeputados` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `camaraObterDeputados`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN
	
	DECLARE contadorWhile INT DEFAULT 1;
	DECLARE contadorTag INT;
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/deputados/deputado)');	
	
	WHILE (contadorWhile <= contadorTag) DO 
		INSERT IGNORE INTO camara_deputado (ideCadastro, codProcessamento, codOrcamento, condicao, 
			matricula, idParlamentar, nome, nomeParlamentar, urlFoto, sexo, uf, 
			partido, gabinete, anexo, fone, email)
		SELECT 
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/ideCadastro'),
			codProcessamento,
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/codOrcamento'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/condicao'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/matricula'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/idParlamentar'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/nome'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/nomeParlamentar'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/urlFoto'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/sexo'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/uf'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/partido'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/gabinete'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/anexo'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/fone'),
			EXTRACTVALUE(xml, '/deputados/deputado[$contadorWhile]/email');
		SET contadorWhile := contadorWhile + 1;
	END WHILE;	
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `camaraObterPartidosCD` */

/*!50003 DROP PROCEDURE IF EXISTS  `camaraObterPartidosCD` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `camaraObterPartidosCD`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN

	DECLARE contadorWhile INT DEFAULT 1;
	DECLARE contadorTag INT;
	DECLARE _dataCriacao VARCHAR(100);
	DECLARE _dataExtincao VARCHAR(100);
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/partidos/partido)');
	
	WHILE (contadorWhile <= contadorTag) DO 
		SET _dataCriacao := EXTRACTVALUE(xml, '/partidos/partido[$contadorWhile]/dataCriacao');
		SET _dataExtincao := EXTRACTVALUE(xml, '/partidos/partido[$contadorWhile]/dataExtincao');
		INSERT IGNORE INTO camara_partido (idPartido, codProcessamento, siglaPartido, nomePartido, dataCriacao, dataExtincao)
		SELECT 
			EXTRACTVALUE(xml, '/partidos/partido[$contadorWhile]/idPartido'),
			codProcessamento,
			EXTRACTVALUE(xml, '/partidos/partido[$contadorWhile]/siglaPartido'),
			EXTRACTVALUE(xml, '/partidos/partido[$contadorWhile]/nomePartido'),
			(CASE WHEN STR_TO_DATE(TRIM(_dataCriacao), '%d/%m/%Y') = '0000-00-00' THEN NULL ELSE STR_TO_DATE(TRIM(_dataCriacao), '%d/%m/%Y') END),
			(CASE WHEN STR_TO_DATE(TRIM(_dataExtincao), '%d/%m/%Y') = '0000-00-00' THEN NULL ELSE STR_TO_DATE(TRIM(_dataExtincao), '%d/%m/%Y') END);
		SET contadorWhile := contadorWhile + 1;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `camaraObterProposicaoPorID` */

/*!50003 DROP PROCEDURE IF EXISTS  `camaraObterProposicaoPorID` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `camaraObterProposicaoPorID`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN

	DECLARE _idProposicaoPrincipal VARCHAR(10);
	DECLARE _ideCadastro INT(11);
	SET _idProposicaoPrincipal := EXTRACTVALUE(xml, '/proposicao/idProposicaoPrincipal');
	SET _ideCadastro := EXTRACTVALUE(xml, '/proposicao/ideCadastro');
	INSERT IGNORE INTO camara_proposicao (tipo, numero, ano, codProcessamento, nomeProposicao, idProposicao, 
		idProposicaoPrincipal, nomeProposicaoOrigem, tipoProposicao, tema, Ementa, ExplicacaoEmenta, 
		Autor, ideCadastro, ufAutor, partidoAutor, DataApresentacao, RegimeTramitacao, UltimoDespacho, 
		Apreciacao, Indexacao, Situacao, LinkInteiroTeor, apensadas, DATA)
	SELECT 
		TRIM(EXTRACTVALUE(xml, '/proposicao/@tipo')),
		EXTRACTVALUE(xml, '/proposicao/@numero'),
		EXTRACTVALUE(xml, '/proposicao/@ano'),
		codProcessamento,
		EXTRACTVALUE(xml, '/proposicao/nomeProposicao'),
		EXTRACTVALUE(xml, '/proposicao/idProposicao'),
		(CASE WHEN (SELECT _idProposicaoPrincipal REGEXP '[0-9]') = 1 THEN _idProposicaoPrincipal ELSE NULL END),		
		EXTRACTVALUE(xml, '/proposicao/nomeProposicaoOrigem'),
		EXTRACTVALUE(xml, '/proposicao/tipoProposicao'),
		EXTRACTVALUE(xml, '/proposicao/tema'),
		EXTRACTVALUE(xml, '/proposicao/Ementa'),
		EXTRACTVALUE(xml, '/proposicao/ExplicacaoEmenta'),
		EXTRACTVALUE(xml, '/proposicao/Autor'),
		(CASE WHEN (SELECT _ideCadastro REGEXP '[0-9]') = 1 THEN _ideCadastro ELSE 0 END),
		EXTRACTVALUE(xml, '/proposicao/ufAutor'),
		TRIM(EXTRACTVALUE(xml, '/proposicao/partidoAutor')),
		STR_TO_DATE(EXTRACTVALUE(xml, '/proposicao/DataApresentacao'), '%d/%m/%Y'),
		EXTRACTVALUE(xml, '/proposicao/RegimeTramitacao'),
		EXTRACTVALUE(xml, '/proposicao/UltimoDespacho'),
		EXTRACTVALUE(xml, '/proposicao/Apreciacao'),
		EXTRACTVALUE(xml, '/proposicao/Indexacao'),
		EXTRACTVALUE(xml, '/proposicao/Situacao'),
		EXTRACTVALUE(xml, '/proposicao/LinkInteiroTeor'),
		EXTRACTVALUE(xml, '/proposicao/apensadas'),
		STR_TO_DATE(EXTRACTVALUE(xml, '/proposicao/UltimoDespacho/@Data'), '%d/%m/%Y');
    END */$$
DELIMITER ;

/* Procedure structure for procedure `camaraObterVotacaoProposicao` */

/*!50003 DROP PROCEDURE IF EXISTS  `camaraObterVotacaoProposicao` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `camaraObterVotacaoProposicao`(IN `xml` MEDIUMTEXT, IN `codProcessamento` INT)
BEGIN
   
	DECLARE contadorWhileVotacao INT DEFAULT 1;
	DECLARE contadorTagVotacao INT;
	
	DECLARE contadorWhileDeputados INT DEFAULT 1;
	DECLARE contadorTagDeputados INT;	
	
	DECLARE _sigla VARCHAR(20);
	DECLARE _numero INT;
	DECLARE _ano INT;
	DECLARE _objVotacao VARCHAR(255);
	DECLARE _data VARCHAR(20);
	DECLARE _hora TIME;
	DECLARE _codSessao INT;
	
	SET contadorTagVotacao := EXTRACTVALUE(xml, 'COUNT(/proposicao/Votacoes/Votacao)');	
	SET _sigla := EXTRACTVALUE(xml, '/proposicao/Sigla');
	SET _numero := EXTRACTVALUE(xml, '/proposicao/Numero');
	SET _ano := EXTRACTVALUE(xml, '/proposicao/Ano');	
	
	
	WHILE (contadorWhileVotacao <= contadorTagVotacao) DO 
		SET contadorTagDeputados := EXTRACTVALUE(xml, 'COUNT(/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/votos/Deputado)');
		SET _objVotacao := EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@ObjVotacao');
		SET _data := STR_TO_DATE(EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@Data'), '%d/%m/%Y');
		SET _hora := EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@Hora');
		SET _codSessao := EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@codSessao');		
		
		WHILE (contadorWhileDeputados <= contadorTagDeputados) DO 
			
			INSERT IGNORE INTO camara_votacaoproposicao (codProcessamento, Sigla, Numero, Ano, Nome, ideCadastro, 
				Partido, UF, Voto, ObjVotacao, DATA, Hora, codSessao)
			SELECT 
				codProcessamento,
				_sigla,
				_numero,
				_ano,
				EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/votos/Deputado[$contadorWhileDeputados]/@Nome'),
				EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/votos/Deputado[$contadorWhileDeputados]/@ideCadastro'),
				TRIM(EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/votos/Deputado[$contadorWhileDeputados]/@Partido')),
				EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/votos/Deputado[$contadorWhileDeputados]/@UF'),	
				TRIM(EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/votos/Deputado[$contadorWhileDeputados]/@Voto')),	
				_objVotacao,	
				_data,		
				_hora,
				_codSessao;			
			SET contadorWhileDeputados := contadorWhileDeputados + 1;
		END WHILE;
		SET contadorWhileDeputados := 1;
		INSERT IGNORE INTO camara_proposicaoresumo (codProcessamento, Resumo, DATA, Hora, ObjVotacao, codSessao, Sigla, Numero, Ano)
		SELECT 
			codProcessamento,
			EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@Resumo'),
			STR_TO_DATE(EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@Data'), '%d/%m/%Y'),
			EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@Hora'),
			EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@ObjVotacao'),
			EXTRACTVALUE(xml, '/proposicao/Votacoes/Votacao[$contadorWhileVotacao]/@codSessao'),
			_sigla,
			_numero,
			_ano;
		SET contadorWhileVotacao := contadorWhileVotacao + 1;
	END WHILE;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
