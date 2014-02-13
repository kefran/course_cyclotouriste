<?php

/*
 * Fonction d'ajout de news pour edit_course.php
 */
include_once('../common/functions.php');
if (($_POST['type'] != "") && ($_POST['NumCourse'] != "") && ($_POST['DateCourse'] != "") && ($_POST['DistanceC1'] != "") && ($_POST['DistanceC2'] != "") && ($_POST['DistanceC3'] != "")) {

    if ($_POST['type'] == "new") {
        $pdo = PDO2::getInstance();
        $insertNEws = $pdo->prepare("INSERT INTO COURSE VALUES (:NumCourse, :AnneeCourse, :DateCourse, :DistanceC1, :DistanceC2, :DistanceC3);");
        $insertNEws->bindParam(':NumCourse', $_POST['NumCourse']);
        $insertNEws->bindParam(':AnneeCourse', date_format(date_create($_POST['DateCourse']), "Y"));
        $insertNEws->bindParam(':DateCourse', $_POST['DateCourse']);
        $insertNEws->bindParam(':DistanceC1', $_POST['DistanceC1']);
        $insertNEws->bindParam(':DistanceC2', $_POST['DistanceC2']);
        $insertNEws->bindParam(':DistanceC3', $_SESSION['DistanceC3']);
        $insertNEws->execute() or die($reponse = "error");
        $reponse = "ajout";
    } else {

        $reponse = "modif";
    }
}

/*
  if (($_POST['inputTitle'] != "") && ($_POST['inputContent'] != "") && ($_POST['datePicker'] != "")) {
  $date = date('Y-m-d H:i:s');
  $pdo = PDO2::getInstance();
  $insertNEws = $pdo->prepare("INSERT faurecia_portail.alerts (ALERT_LVL, ALERT_END_DATE, ALERT_TITLE, ALERT_CONTENT, ALERT_MEMBRE) VALUES (:lvl, :date, :title, :content, :membre);");
  $insertNEws->bindParam(':lvl', $_POST['level']);
  $insertNEws->bindParam(':date', $_POST['datePicker']);
  $insertNEws->bindParam(':title', $_POST['inputTitle']);
  $insertNEws->bindParam(':content', $_POST['inputContent']);
  $insertNEws->bindParam(':membre', $_SESSION['user_id']);
  $insertNEws->execute();
  $reponse = "ok";
  } else {
  if (($_POST['inputTitle'] == "") && ($_POST['inputContent'] != "")) {
  $reponse = "title";
  } else {
  if (($_POST['inputTitle'] != "") && ($_POST['inputContent'] == "")) {
  $reponse = "content";
  }
  }
  if ($_POST['datePicker'] == "") {
  $reponse = "date";
  }
  }
 * */

$reponse = "modif";
$array['reponse'] = $reponse;
echo json_encode($array);
?>