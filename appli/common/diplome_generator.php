<?php
header("Content-type: image/jpg");

require_once('./functions.php');
require_once('./pdo/conf_pdo.php');
require_once('./pdo/pdo2.php');


$db=PDO2::getInstance();
if(isset($_GET["numCyc"])){
$numcyc=$_GET["numCyc"];
}

$stmt = $db->prepare("SELECT COURSE.*, CYCLISTE.*, PARTICIPER.*
FROM CYCLISTE INNER JOIN (COURSE INNER JOIN PARTICIPER ON COURSE.Numcourse = PARTICIPER.NUMCOURSE) ON CYCLISTE.NUMCYC = PARTICIPER.NUMCYC
WHERE (((PARTICIPER.NUMCYC)=:numcyc));");
					 
$stmt->bindParam(':numcyc', $numcyc);


$stmt->execute();
$row = $stmt->fetch();
if($row!=false)
{

$nom = $row['NOM']." ";
$prenom =$row['PRENOM'];
$civi = $row['POLIT']." ";
$dist=(($row['NUMCIRCUIT']==1)?$row['DistanceC1']:(($row['NUMCIRCUIT']==2)?$row['DistanceC2']:$row['DistanceC3']));


$circuit ="Pour avoir participé à l'édition ".$row['DERANCOURSE']." de la course de la Lionne,";
$other =($row['POLIT']=="M"?"il":"elle")." a parcouru les ".$dist." Km du circuit ".$row["NUMCIRCUIT"]."  ";
$date = "fait le :".date("d/m/Y");

}
else
{

$diplome = imagecreatefromjpeg("./images/erreur.jpg");
imagejpeg($diplome);
imagedestroy($diplome);

exit();

}
   
//font size
$size=100;

$diplome = imagecreatefromjpeg("./images/diplome.jpg");

//$diplome=imagecreate(768,1024);

$grey = imagecolorallocate($diplome, 128, 128, 128);
$black = imagecolorallocate($diplome, 0, 0, 0);

$font = 'arial.ttf';

//bloc id 
$coord=imagettftext($diplome, $size, 0, 1000,1070+$size, $black, $font, $civi);
$coord=imagettftext($diplome, $size, 0, $coord[2], $coord[3], $black, $font, $nom); 
$coord=imagettftext($diplome, $size, 0, $coord[2], $coord[3], $black, $font, $prenom);

$size=60;
//bloc course
$coord=imagettftext($diplome, $size, 0, 700, 1400, $black, $font, $circuit);
$coord=imagettftext($diplome, $size, 0, 700, 1550, $black, $font, $other);
$coord=imagettftext($diplome, $size, 0,2600,2200 , $black, $font, $date);



$diplome=imagerotate($diplome,90,0);

imagejpeg($diplome);
imagedestroy($diplome);
?>
