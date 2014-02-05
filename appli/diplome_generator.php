<?php
header("Content-type: image/png");
$diplome = imagecreatefromjpeg("./diplome.jpg");

$grey = imagecolorallocate($diplome, 128, 128, 128);
$black = imagecolorallocate($diplome, 0, 0, 0);


$text = 'TeXte , je suis du Texte, qui suis-je ?';

$font = 'Cartoon_Reg.ttf';

imagettftext($diplome, 20, 0, 110, 210, $grey, $font, $text);

imagettftext($diplome, 20, 0, 100, 200, $black, $font, $text);


imagepng($diplome);
?>
