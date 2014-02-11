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
    while ($recCourse = $selectCourse->fetch()) {
        echo "<tr><td>" . $recCourse->Numcourse . "</td><td>" .  date_format(date_create($recCourse->DateCourse),"d/m/Y") . "</td><td>" .  date_format(date_create($recCourse->DateCourse),"Y") . "</td><td>" . $recCourse->NbParticipantsTotal . "</td><td>" . $recCourse->NbParticipantsC1 . "</td><td>" . $recCourse->NbParticipantsC2 . "</td><td>" . $recCourse->NbParticipantsC3 . "</td></tr>";
    }
}
?>
