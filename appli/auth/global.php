<?php


session_start();
$stradmin_pass = "lionne";

/*
 *
 *
 *			COMMON FUNCTIONS
 *
 *
 */
function printgetpost()
{
	echo "-----------   DEBUG   ------------\n<br>";

	echo 'stradminpass = ' . $GLOBALS["stradmin_pass"] . "\n";

	echo "VAR GET\n";
	echo '<PRE>' . print_r($_GET) . '</PRE>';

	echo "VAR POST\n";
	echo '<PRE>' . print_r($_POST) . '</PRE>';

	echo "----------------------------------\n<br>";
}



function isAdmin()
{
	if(isset($_SESSION['strAdmin']) and $_SESSION['strAdmin'])
	{
		error_log("This visitor is an admin");
	}
	else
	{
		error_log("Unknown. redirect to login page");
		header('Location: /lionne/fr/login_admin.asp');
	}
}



?>