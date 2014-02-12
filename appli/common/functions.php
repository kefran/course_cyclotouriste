<?php

require_once('..\common\init.php');

function getCourseListe() {

    $pdo = PDO2::getInstance();
    $selectCourse = $pdo->query("SELECT 
                                    *
                                FROM 
                                    COURSE
                                ORDER BY COURSE.Numcourse DESC;
");
    $selectCourse->execute();
    $selectCourse->setFetchMode(PDO::FETCH_OBJ);
    $line = 1;
    while ($recCourse = $selectCourse->fetch()) {
        if ($line == 1) {
            $line_class = "tab_line_1";
            $line = 2;
        } else {
            $line_class = "tab_line_2";
            $line = 1;
        }
        if ($recCourse->DateCourse == "") {
            $date = "";
        } else {
            $date = date_format(date_create($recCourse->DateCourse), "d/m/Y");
        }
        echo "<tr class='" . $line_class . "'><td>" . $recCourse->Numcourse . "</td>"
        . "<td>" . $date . "</td>"
        . "<td>" . $recCourse->AnneeCourse . "</td>"
        . "<td>" . $recCourse->NbParticipantsTotal . "</td>"
        . "<td>" . $recCourse->NbParticipantsC1 . "</td>"
        . "<td>" . $recCourse->NbParticipantsC2 . "</td>"
        . "<td>" . $recCourse->NbParticipantsC3 . "</td>"
        . "<td> <a href='edit_courses.php?numcourse=" . $recCourse->Numcourse . "'><i class='icon icon-edit'></i></td></tr>";
    }
}

function getEditCourse() {

    $pdo = PDO2::getInstance();
    $selectCourse = $pdo->query("Select * from COURSE WHERE Numcourse=23");
    $selectCourse->execute();
    $selectCourse->setFetchMode(PDO::FETCH_OBJ);
    return $selectCourse->fetch();
}
?>
