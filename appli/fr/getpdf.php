<?php
$f=$HTTP_GET_VARS['f'];
//Contr�le du fichier (� ne pas oublier !)
if(substr($f,0,3)!='tmp' or strpos($f,'/') or strpos($f,'\\'))
    die("Nom de fichier incorrect");
if(!file_exists($f))
    die("Le fichier n'existe pas");
//Traitement de la requ�te sp�ciale IE au cas o�
if($HTTP_SERVER_VARS['HTTP_USER_AGENT']=='contype')
{
    Header('Content-Type: application/pdf');
    exit;
}
//Envoi du PDF
Header('Content-Type: application/pdf');
Header('Content-Length: '.filesize($f));
readfile($f);
//Suppression du fichier
unlink($f);
exit;
?> 