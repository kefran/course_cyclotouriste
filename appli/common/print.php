<?php

require_once('./common/functions.php');
require_once('./common/pdo/conf_pdo.php');
require_once('./common/pdo/pdo2.php');


$tmp = new PDO2();
$db=$tmp->getInstance();

$stmt = $db->prepare("SELECT * FROM CYCLISTE WHERE NUMCYC= :numcyc");
$stmt->bindParam(':numcyc', $numcyc);

$numcyc=1;
$stmt->execute();
while ($row = $stmt->fetch()) {
    print_r($row);
  }
echo "<html><head></head>";

?>
<body onload="">

<img  width="100%" height="100%" src="./diplome_generator.php?numCyc=1" alt="un diplome" />


</body></html>