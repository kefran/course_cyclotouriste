<?php

include('..\global.php');

$debug=True;

if( isset($_POST['pass']) and ($_POST['pass'] == $GLOBALS["stradmin_pass"]) )
{
	if($debug) { error_log("Test auth. LOGIN IS OK. Authenticated!"); }
	$_SESSION['strAdmin'] = True;
}
else
{
	if($debug) { error_log("Test auth. LOGIN IS NOK. Not authenticated"); }
}

//echo "strURL = " . $_POST['strURL'] . "\n";
header("Location: /lionne/fr/". $_POST['strURL']); 


?>