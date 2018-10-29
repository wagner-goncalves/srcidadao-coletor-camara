<?php

    namespace SrCidadao\Coletor\Camara;

	use SrCidadao\Coletor\Camara\Config\Config;
	use SrCidadao\Coletor\Util\Util;
	use SrCidadao\Coletor\Util\HttpReader;
	use SrCidadao\Coletor\Util\MensagemSistema;

	class Downloader{

		private $codProcessamento;
		
		public function __construct($codProcessamento = 0){            
			$this->codProcessamento = $codProcessamento;
		}
		
		public function obterPartidosCD(){
            $codProcessamento = 0;  
            $arquivo = "";
			try{
				$objConfig = new Config();
				$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);
				if(!file_exists($arquivo)){
					$objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
					$objHttpReader->urlSave($arquivo);
				}
                return ["success" => true, "arquivo" => $arquivo, "message" => "Download com sucesso"];	
			}catch(\Exception $e){
				echo $e->getTraceAsString();
                //Salva log com resultados do processamento
                return ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
			}
		}
		
		public function obterDeputados(){
            $arquivo = "";
                       
			try{
				$objConfig = new Config();
                $url = $objConfig->getUrl(__FUNCTION__, "Url");
				$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);
				if(!file_exists($arquivo)){
					$objHttpReader = new HttpReader($url);
					$objHttpReader->urlSave($arquivo);
				}

                return ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];		
			}catch(\Exception $e){
                return ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
			}
		}
		
		public function listarPresencasDia($dataInicial, $dataFinal){
            $arquivo = "";     
            
			$objConfig = new Config();
			$respostas = array();

			$objDataInicial = \DateTime::createFromFormat("d/m/Y", $dataInicial);
			$objDataFinal = \DateTime::createFromFormat("d/m/Y", $dataFinal);
			$dias = floor((strtotime($objDataFinal->format("Y-m-d")) - strtotime($objDataInicial->format("Y-m-d")))/(60*60*24));

            for($i = 0; $i < $dias + 1; $i++){
				$data = date("d/m/Y", strtotime($objDataInicial->format("Y-m-d") . " +" . ($i * (60 * 60 * 24)) . " seconds"));	
				try{
                    $dataArquivo = ("-" . str_replace("/", "-", $data));
					$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $dataArquivo);	
					$sucesso = [];
					
					if(file_exists($arquivo)){				

					}else{
						$objConfig->setParametroUrl(__FUNCTION__, "data", $data);
						$objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
						$objHttpReader->urlSave($arquivo);
					}
					
					$respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];

				}catch(\Exception $e){
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
				}
			}

			return $respostas;	
		}	
		
		public function listarProposicoesVotadasEmPlenario($anoInicial, $anoFinal){
            $arquivo = "";              
			$respostas = array();

			$anos = $anoFinal - $anoInicial;
			
            for($ano = $anoInicial; $ano < $anoFinal + 1; $ano++){
				
				$dataArquivo = "";
			    try{                
                    $objConfig = new Config();
					$objConfig->setParametroUrl(__FUNCTION__, "ano", $ano);
					
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $ano); 
					if(!file_exists($arquivo)){
						$objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
						$objHttpReader->urlSave($arquivo);
					}
                    
					$respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
                }catch(\Exception $e){
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
                }                
            }
			return $respostas;	
		}	

		public function obterProposicaoPorID($dataInicial, $dataFinal){
            $arquivo = "";  			
            
            $respostas = array();

            $arrCodProposicao = $this->listarProposicoesVotadasEmPlenarioPorData($dataInicial, $dataFinal); 
			
            $objConfig = new Config();
				
            foreach($arrCodProposicao as $item){
                try{                
                    $objConfig->setParametroUrl(__FUNCTION__, "IdProp", $item);
                    
                    $codProposicao = ("-" . $item);
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $codProposicao);
					
					if(!file_exists($arquivo)){
						$objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
						$objHttpReader->urlSave($arquivo);
					}
					
					$respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
                }catch(\Exception $e){
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
                }                    
            }

            if(count($respostas) == 0){
                $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
            }
            
			return $respostas;	
		}	
		
		public function obterVotacaoProposicao($dataInicial, $dataFinal){
            $arquivo = "";  		            
			$respostas = array();

			$arrCodProposicao = $this->listarProposicoesPorData($dataInicial, $dataFinal);

            $objConfig = new Config();
            
            if(is_array($arrCodProposicao)){ 
                foreach($arrCodProposicao as $proposicao){
			        try{                    
                        $objConfig->setParametroUrl(__FUNCTION__, "tipo", $proposicao["tipo"]);
                        $objConfig->setParametroUrl(__FUNCTION__, "numero", $proposicao["numero"]);
						$objConfig->setParametroUrl(__FUNCTION__, "ano", $proposicao["ano"]);
						
                        $codProposicao = $proposicao["idProposicao"]; //("-" . $item["codProposicao"]);
                        $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, ("-" . $proposicao["idProposicao"]));

						if(!file_exists($arquivo)){
							$objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
							$objHttpReader->urlSave($arquivo);
						}

                        $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
                    }catch(\Exception $e){
                        $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
                    }                        
                }
            }
            
            if(count($respostas) == 0){
                $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
            }            

			return $respostas;	
		}
		
		public function listarProposicoesPorData($dataInicial = "", $dataFinal = ""){
			if($dataInicial == "" && $dataFinal == "") $dataInicial = $dataFinal = date("d/m/Y");
			if($dataInicial != "" && $dataFinal == "") $dataFinal = date("d/m/Y");		
			$objDataInicial = \DateTime::createFromFormat("d/m/Y", $dataInicial);
			$objDataFinal = \DateTime::createFromFormat("d/m/Y", $dataFinal);	
			
			$dataInicial = $objDataInicial->format("Y-m-d");
			$dataFinal = $objDataFinal->format("Y-m-d");
			
						
			$objDB = Util::getDB();
			$arrCodProposicao = $objDB->query("SELECT p.idProposicao, p.tipo, p.numero, p.ano FROM camara_proposicao p
				INNER JOIN camara_proposicaoplenario pp on pp.codProposicao = p.idProposicao
				WHERE pp.dataVotacao BETWEEN '" . $dataInicial . "' AND '" . $dataFinal . "'")->fetchAll(\PDO::FETCH_ASSOC);
			return $arrCodProposicao;	
		}		
		
		public function listarProposicoesVotadasEmPlenarioPorData($dataInicial = "", $dataFinal = ""){
			if($dataInicial == "" && $dataFinal == "") $dataInicial = $dataFinal = date("d/m/Y");
			if($dataInicial != "" && $dataFinal == "") $dataFinal = date("d/m/Y");		
			$objDataInicial = \DateTime::createFromFormat("d/m/Y", $dataInicial);
			$objDataFinal = \DateTime::createFromFormat("d/m/Y", $dataFinal);	
			
			$dataInicial = $objDataInicial->format("Y-m-d");
			$dataFinal = $objDataFinal->format("Y-m-d");
						
			$objDB = Util::getDB();
			$arrCodProposicao = $objDB->select("camara_proposicaoplenario", "codProposicao", array("dataVotacao[<>]" => array($dataInicial, $dataFinal)));
			return $arrCodProposicao;	
		}
	}
