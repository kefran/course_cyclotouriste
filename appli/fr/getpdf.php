<?php
$f=$_GET['f'];
//Contrôle du fichier (à ne pas oublier !)
if(substr($f,0,3)!='tmp' or strpos($f,'/') or strpos($f,'\\'))
    die("Nom de fichier incorrect");
if(!file_exists($f))
    die("Le fichier n'existe pas");

//Envoi du PDF
Header('Content-Type: application/pdf');
Header('Content-Length: '.filesize($f));
readfile($f);
//Suppression du fichier
unlink($f);
exit;
?> 