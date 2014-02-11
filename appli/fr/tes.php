<?php

require_once('..\common\init.php');
$filehandler = fopen("insert_partic.sql", "r");
while (!feof($filehandler)) {
    echo fgets($filehandler) . "<br>";
}

fclose($filehandler);

?>