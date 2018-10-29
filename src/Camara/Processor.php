<?php

    namespace SrCidadao\Coletor\Camara;

	use SrCidadao\Coletor\Camara\Config\Config;
	use SrCidadao\Coletor\Util\Util;
	use SrCidadao\Coletor\Util\HttpReader;
	use SrCidadao\Coletor\Util\MensagemSistema;
	use SrCidadao\Coletor\Camara\Downloader;
	

	class Processor{

		private $objDownloader;
		private $codProcessamento = 0;
		
		public function __construct($codProcessamento){
			$this->codProcessamento = $codProcessamento;
		}
		
		private function arquivoJaProcessado($arquivo){
			$path_parts = pathinfo($arquivo);
            $novoArquivo = $path_parts['dirname'] . "/OK-" . $path_parts['filename'] . "." . $path_parts['extension'];
            return file_exists($novoArquivo);
		}
		
		private function finalizarProcessamento($arquivo){
			return $arquivo;
		} 	
		
		public function obterPartidosCD(){
			$objDB = null;

            $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento); 

			try{           
				$objDB = Util::getDB();

				$xml = file_get_contents($arquivo);
				$sql = "CALL camaraObterPartidosCD(?, ?)";
				$stmt = $objDB->pdo->prepare($sql);
				$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
				$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
				$stmt->execute();				

				$error = $objDB->error();	
				if(intval($error[0]) > 0) throw new \Exception("Erro ao processar arquivo.");
                
				$novoArquivo = $this->finalizarProcessamento($arquivo);
				
				return ["arquivo" => $novoArquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
			}catch(\Exception $e){
				echo $e->getTraceAsString();
                return ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
			}
		}
		
		public function obterDeputados(){
			$objDB = null;
            $arquivo = "";            
            
			try{
                
				$objDB = Util::getDB();
				$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);
				
				$xml = file_get_contents($arquivo);
				$sql = "CALL camaraObterDeputados(?, ?)";
				$stmt = $objDB->pdo->prepare($sql);
				$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
				$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
				$stmt->execute();					
				
                $error = $objDB->error();
				if(intval($error[0]) > 0) throw new \Exception("Erro ao processar arquivo.");                

				$novoArquivo = $this->finalizarProcessamento($arquivo);
                
				return ["arquivo" => $novoArquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
			}catch(\Exception $e){                
                return ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
			}
		}
		
		public function listarPresencasDia($dataInicial, $dataFinal){

            $arquivo = "";
                       
			$respostas = array();
			$objDB = null;

            if($dataInicial == "" && $dataFinal == "") $dataInicial = $dataFinal = date("d/m/Y");
            if($dataInicial != "" && $dataFinal == "") $dataFinal = date("d/m/Y");
            $objDataInicial = \DateTime::createFromFormat("d/m/Y", $dataInicial);
            $objDataFinal = \DateTime::createFromFormat("d/m/Y", $dataFinal);
            $dias = floor((strtotime($objDataFinal->format("Y-m-d")) - strtotime($objDataInicial->format("Y-m-d")))/(60*60*24));
            
            $objDB = Util::getDB();
			
            for($i = 0; $i < $dias + 1; $i++){
                
                try{
                    $data = date("d/m/Y", strtotime($objDataInicial->format("Y-m-d") . " +" . ($i * (60 * 60 * 24)) . " seconds"));	
                    $dataArquivo = ("-" . str_replace("/", "-", $data));
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $dataArquivo);
					
					$xml = file_get_contents($arquivo);
					
					$sucesso = [];
					
					if(false && $this->arquivoJaProcessado($arquivo)){

					}else{
						
						$sql = "CALL camaraListarPresencasDia(?, ?)";
						$stmt = $objDB->pdo->prepare($sql);
						$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
						$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
						$stmt->execute();	
						
						$error = $objDB->error();				
						if(intval($error[0]) > 0) throw new \Exception("Erro ao processar arquivo."); 

						$novoArquivo = $this->finalizarProcessamento($arquivo);

					}
                    
					$respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
                }catch(\Exception $e){
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
                }   
				
            }
			
			return $respostas;	
		}	
		
		public function listarProposicoesVotadasEmPlenario($anoInicial, $anoFinal){
            $arquivo = "";     

			$respostas = array();
			
			$objDB = null;

            if($anoInicial == "" && $anoFinal == "") $anoInicial = $anoFinal = date("Y");
            if($anoInicial != "" && $anoFinal == "") $anoFinal = date("Y");
            $anos = $anoFinal - $anoInicial;
            $objDB = Util::getDB();
			
            for($ano = $anoInicial; $ano < $anoFinal + 1; $ano++){
				
			    try{                
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $ano);
					$xml = file_get_contents($arquivo);

					$sql = "CALL camaraListarProposicoesVotadasEmPlenario(?, ?)";
					$stmt = $objDB->pdo->prepare($sql);
					$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
					$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
					$stmt->execute();						

					$error = $objDB->error();	
					print_r($error);		
                    if(intval($error[0]) > 0) throw new \Exception("Erro ao processar arquivo.");                        
                        
                    $novoArquivo = $this->finalizarProcessamento($arquivo);
					$respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
                }catch(\Exception $e){
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
                }                    
            }
			return $respostas;	
		}	
		
		public function obterProposicaoPorID($dataInicial, $dataFinal){
            $arquivo = "";  			

			$respostas = array();
			$objDB = null;
			$this->objDownloader = new Downloader();
			$arrCodProposicao = $this->objDownloader->listarProposicoesVotadasEmPlenarioPorData($dataInicial, $dataFinal);

			$objDB = Util::getDB();
			if(is_array($arrCodProposicao)){					
				foreach($arrCodProposicao as $item){
					
					try{
					
						$codProposicao = ("-" . $item);
						$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $codProposicao);
						//if($this->arquivoProcessado($arquivo)) throw new \Exception("Arquivo já processado.");
						
						$xml = file_get_contents($arquivo);
						$sql = "CALL camaraObterProposicaoPorID(?, ?)";
						$stmt = $objDB->pdo->prepare($sql);
						$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
						$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
						$stmt->execute();								
						
						$error = $objDB->error();				
						if(intval($error[0]) > 0) throw new \Exception("Erro ao processar arquivo.");                               
						
						$novoArquivo = $this->finalizarProcessamento($arquivo);
						$respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
					}catch(\Exception $e){
						$respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
					}                            
				}
				
			}

			return $respostas;	
		}	

		public function obterVotacaoProposicao($dataInicial, $dataFinal){
            $arquivo = "";  	                
            
			$respostas = array();
			$objDB = null;
			$this->objDownloader = new Downloader();
            $arrCodProposicao = $this->objDownloader->listarProposicoesPorData($dataInicial, $dataFinal);

            $objDB = Util::getDB();
            if(is_array($arrCodProposicao)){ 

                foreach($arrCodProposicao as $proposicao){
			        try{                    
                        $codProposicao = ("-" . $proposicao["idProposicao"]);
						$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $codProposicao);
						//if($this->arquivoProcessado($arquivo)) throw new \Exception("Arquivo já processado.");

						$xml = file_get_contents($arquivo);
						
						$sql = "CALL camaraObterVotacaoProposicao(?, ?)";
						$stmt = $objDB->pdo->prepare($sql);
						$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
						$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
						$stmt->execute();	
                        
                        $error = $objDB->error();				
                        if(intval($error[0]) > 0) throw new \Exception($sql);                               

                        $novoArquivo = $this->finalizarProcessamento($arquivo);					
                        $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
                    }catch(\Exception $e){                     
                        $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
                    }
                }
            }
			return $respostas;	
		}
	}
