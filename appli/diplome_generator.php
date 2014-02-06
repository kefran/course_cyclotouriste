<?php
header("Content-type: image/jpg");
$diplome = imagecreatefromjpeg("./diplome.jpg");

$grey = imagecolorallocate($diplome, 128, 128, 128);
$black = imagecolorallocate($diplome, 0, 0, 0);

if(isset($_GET["text"])){
$text=$_GET["text"];
}else{
$text = 'TeXte , je suis du Texte, qui suis-je ?';
}
$font = 'Cartoon_Reg.ttf';

imagettftext($diplome, 20, 0, 80, 210, $grey, $font, $text);

imagettftext($diplome, 20, 0, 90, 200, $black, $font, $text);

//$diplome=imagerotate($diplome,90,0);

imagepng($diplome);
imagedestroy($diplome);
?>
