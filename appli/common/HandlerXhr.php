<?php
require_once('./functions.php');
require_once('./pdo/conf_pdo.php');
require_once('./pdo/pdo2.php');

header('Content-Type: text/xml;');

$db=PDO2::getInstance();
$token="";
if(isset($_GET["search"])){
$token.=$_GET["search"];
$token.="%";



$stmt = $db->prepare("SELECT * FROM CYCLISTE C WHERE C.NOM LIKE :token ");
					 
$stmt->bindParam(':token', $token);

$stmt->execute();


$xml = new XMLWriter();

$xml->openURI("php://output");
$xml->startDocument();
$xml->setIndent(true);

$xml->startElement('cyclistes');

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
  $xml->startElement("cycliste");
  	
  	 $xml->startElement("numcyc");
 	 $xml->writeRaw(htmlspecialchars($row['NUMCYC']));
 	 $xml->endElement();
 	 
 	 $xml->startElement("nom");
 	 $xml->writeRaw(htmlspecialchars($row['NOM']));
 	 $xml->endElement();
 	 
 	 $xml->startElement("prenom");
 	 $xml->writeRaw(htmlspecialchars($row['PRENOM']));
 	 $xml->endElement();

$xml->endElement();
 
}
$xml->endElement();

$xml->flush();



}


?>