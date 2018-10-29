<?php 

//Recupera variáveis do ambiente
$dotenv = new Dotenv\Dotenv(__DIR__ . "/../src/Camara/Config/", ".config");
$dotenv->load();

use PHPUnit\Framework\TestCase;

/**
*  Corresponding Class to test YourClass class
*
*  For each class in your library, there should be a corresponding Unit-Test for it
*  Unit-Tests should be as much as possible independent from other test going on.
*
*  @author yourname
*/
class DownloaderTest extends TestCase
{

    private function getDownloader($codProcessamento){
        return new SrCidadao\Coletor\Camara\Downloader($codProcessamento);
    }

    private function getProcessor($codProcessamento){
        return new SrCidadao\Coletor\Camara\Processor($codProcessamento);
    }    
/*
    public function testObterPartidosCD()
    {
      $result = $this->getDownloader(1)->obterPartidosCD();
      print_r($result);

      $result = $this->getProcessor(1)->obterPartidosCD();      
      print_r($result);

      $this->assertTrue($result["success"]);
    } 

    public function testObterDeputados()
    {
      $downloader = $this->getDownloader(1);
      $result = $this->getDownloader(1)->obterDeputados();
      print_r($result);

      $result = $this->getProcessor(1)->obterDeputados();      
      print_r($result);

      $this->assertTrue($result["success"]);
    } 

    public function testListarPresencasDia()
    {
      $result = $this->getDownloader(1)->listarPresencasDia("01/09/2018", "10/09/2018");
      print_r($result);

      $result = $this->getProcessor(1)->listarPresencasDia("01/09/2018", "10/09/2018");
      print_r($result);

      $this->assertTrue(is_array($result));
    }  
*/    
    public function testListarProposicoesVotadasEmPlenario()
    {
      $result = $this->getDownloader(1)->listarProposicoesVotadasEmPlenario(date("Y"), date("Y"));
      print_r($result);

      $result = $this->getProcessor(1)->listarProposicoesVotadasEmPlenario(date("Y"), date("Y"));
      print_r($result);

      $this->assertTrue(is_array($result));
    }      

    public function testObterProposicaoPorID()
    {
      $result = $this->getDownloader(1)->obterProposicaoPorID("01/07/2018", "10/09/2018");
      print_r($result);

      $result = $this->getProcessor(1)->obterProposicaoPorID("01/07/2018", "10/09/2018");
      print_r($result);

      $this->assertTrue(is_array($result));
    }  
    
    public function testObterVotacaoProposicao()
    {
      $result = $this->getDownloader(1)->obterVotacaoProposicao("01/07/2018", "10/09/2018");
      print_r($result);

      $result = $this->getProcessor(1)->obterVotacaoProposicao("01/07/2018", "10/09/2018");
      print_r($result);

      $this->assertTrue(is_array($result));
    }   
}
