<?php
require_once('./functions.php');
require_once('./pdo/conf_pdo.php');
require_once('./pdo/pdo2.php');

header('Content-Type: text/xml; charset=windows-1252');

$db=PDO2::getInstance();
$token="";
if(isset($_POST["search"])){
$token.=$_POST["search"];
$token.="%";



$stmt = $db->prepare("SELECT * FROM CYCLISTE C WHERE C.NOM LIKE :token  OR C.NUMCYC LIKE :token1 ");
					 
$stmt->bindParam(':token', $token);
$stmt->bindParam(':token1', $token);
$stmt->execute();

$xml = new XMLWriter();

$xml->openURI("php://output");
$xml->startDocument("1.0","windows-1252");
$xml->setIndent(true);

$xml->startElement('cyclistes');

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
  $xml->startElement("cycliste");
  	
  	 $xml->startElement("numcyc");
 	 $xml->writeRaw(htmlspecialchars($row['NUMCYC']));
 	 $xml->endElement();
 	 
 	 $xml->startElement("nom");
 	 $xml->writeRaw(utf8_encode($row['NOM']));
 	 $xml->endElement();
 	 
 	 $xml->startElement("prenom");
 	 $xml->writeRaw(utf8_encode($row['PRENOM']));
 	 $xml->endElement();

$xml->endElement();
 
}
$xml->endElement();

$xml->flush();


}


?>