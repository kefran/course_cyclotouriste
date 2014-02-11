<?php

require_once('..\common\init.php');

function getCourseListe() {

    $tmp = new PDO2();
    $pdo = $tmp->getInstance();
    $selectCourse = $pdo->query("SELECT 
                                    COURSE.Numcourse, 
                                    COURSE.DateCourse, 
                                    COURSE.NbParticipantsTotal, 
                                    COURSE.NbParticipantsC1, 
                                    COURSE.NbParticipantsC2, 
                                    COURSE.NbParticipantsC3
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
        echo "<tr class='" . $line_class . "'><td>" . $recCourse->Numcourse . "</td>"
        . "<td>" . date_format(date_create($recCourse->DateCourse), "d/m/Y") . "</td>"
        . "<td>" . date_format(date_create($recCourse->DateCourse), "Y") . "</td>"
        . "<td>" . $recCourse->NbParticipantsTotal . "</td>"
        . "<td>" . $recCourse->NbParticipantsC1 . "</td>"
        . "<td>" . $recCourse->NbParticipantsC2 . "</td>"
        . "<td>" . $recCourse->NbParticipantsC3 . "</td>"
        . "<td> <a href='edit_courses.php?numcourse=" . $recCourse->Numcourse . "'><i class='icon icon-edit'></i></td></tr>";
    }
}

?>