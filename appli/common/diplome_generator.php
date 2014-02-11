<?php
header("Content-type: image/jpg");

require_once('./functions.php');
require_once('./pdo/conf_pdo.php');
require_once('./pdo/pdo2.php');


$tmp = new PDO2();
$db=$tmp->getInstance();

if(isset($_GET["numCyc"])){
$text=$_GET["numCyc"];
}

$stmt = $db->prepare("SELECT * FROM CYCLISTE WHERE NUMCYC= :numcyc");
$stmt->bindParam(':numcyc', $numcyc);

$numcyc=1;
$stmt->execute();
$row = $stmt->fetch();
if($row!=false)
{

$nom = $row['NOM']." ";
$prenom =$row['PRENOM'];
$civi = "M."." ";
$circuit ="Pour avoir participé à l'édition 2014 de la course de la Lionne, Il a parcouru les X Km du circuit X  ";
$date = "fait le : 21/12/2012";

}else
{
$diplome = imagecreatefromjpeg("./image/erreur.jpg");
imagejpeg($diplome);
imagedestroy($diplome);

exit();

}
   

//font size
$size=100;

$diplome = imagecreatefromjpeg("./image/diplome.jpg");

//$diplome=imagecreate(768,1024);

$grey = imagecolorallocate($diplome, 128, 128, 128);
$black = imagecolorallocate($diplome, 0, 0, 0);

$font = 'arial.ttf';

/*
Array
(
    [0] => 0 // lower left X coordinate
    [1] => -1 // lower left Y coordinate
    [2] => 198 // lower right X coordinate
    [3] => -1 // lower right Y coordinate
    [4] => 198 // upper right X coordinate
    [5] => -20 // upper right Y coordinate
    [6] => 0 // upper left X coordinate
    [7] => -20 // upper left Y coordinate
)
*/
//bloc id 
$coord=imagettftext($diplome, $size, 0, 1000,1070+$size, $black, $font, $civi);
$coord=imagettftext($diplome, $size, 0, $coord[2], $coord[3], $black, $font, $nom); 
$coord=imagettftext($diplome, $size, 0, $coord[2], $coord[3]-30, $black, $font, $prenom);

$size=60;
//bloc course
$coord=imagettftext($diplome, $size, 0, 70, 1400, $black, $font, $circuit);

$coord=imagettftext($diplome, $size, 0,2600,2200 , $black, $font, $date);



//$diplome=imagerotate($diplome,90,0);

imagejpeg($diplome);
imagedestroy($diplome);
?>
