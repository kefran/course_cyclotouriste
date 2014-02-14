<?php

/*
 * Fonction d'ajout de news pour edit_course.php
 */
include_once('../common/functions.php');
if (($_POST['type'] != "") && ($_POST['AnneeCourse'] != "") && ($_POST['DateCourse'] != "") && ($_POST['DistanceC1'] != "") && ($_POST['DistanceC2'] != "") && ($_POST['DistanceC3'] != "")) {

    $pdo = PDO2::getInstance();

    $verifCourse = $pdo->prepare("SELECT * FROM COURSE WHERE AnneeCourse = :annee");
    $verifCourse->bindParam(':annee', $_POST['AnneeCourse']);
    $verifCourse->execute();
    $rows = $verifCourse->fetchAll();
    $num_rows = count($rows);
    if ($num_rows > 0) {
        $reponse = "existe";
    } else {
        if ($_POST['type'] == "new") {
            $reponse = "ajout";

            $insertCourse = $pdo->prepare("INSERT INTO COURSE(Numcourse, DateCourse, AnneeCourse, DistanceC1, DistanceC2, DistanceC3)"
                    . " VALUES (:NumCourse, :DateCourse, :AnneeCourse, :DistanceC1, :DistanceC2, :DistanceC3);");
            $insertCourse->bindParam(':NumCourse', $_POST['NumCourse']);
            $insertCourse->bindParam(':AnneeCourse', $_POST['AnneeCourse']);
            $insertCourse->bindParam(':DateCourse', $_POST['DateCourse']);
            $insertCourse->bindParam(':DistanceC1', $_POST['DistanceC1']);
            $insertCourse->bindParam(':DistanceC2', $_POST['DistanceC2']);
            $insertCourse->bindParam(':DistanceC3', $_POST['DistanceC3']);
            $insertCourse->execute() or die();
        } else {
            $reponse = "modif";

            $updateCourse = $pdo->prepare('UPDATE COURSE
                                    SET DateCourse = :DateCourse, AnneeCourse = :AnneeCourse, DistanceC1 = :DistanceC1,  DistanceC2 = :DistanceC2,  DistanceC3 =  :DistanceC3
                                    where Numcourse = :NumCourse;');
            $updateCourse->bindParam(':NumCourse', $_POST['NumCourse']);
            $updateCourse->bindParam(':AnneeCourse', $_POST['AnneeCourse']);
            $updateCourse->bindParam(':DateCourse', $_POST['DateCourse']);
            $updateCourse->bindParam(':DistanceC1', $_POST['DistanceC1']);
            $updateCourse->bindParam(':DistanceC2', $_POST['DistanceC2']);
            $updateCourse->bindParam(':DistanceC3', $_POST['DistanceC3']);
            $updateCourse->execute() or die($reponse = "error");
        }
    }
}
$reponse = "existe";
$array['reponse'] = $reponse;
echo json_encode($array);
?>