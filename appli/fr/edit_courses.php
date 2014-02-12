<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <title>Site des gestion de la course de la LIONNE</title>
        <link href="../style.css" rel="stylesheet" type="text/css">
        <link href="../bootstrap/css/bootstrap.min.ie.css" rel="stylesheet" media="screen">
        <link href="../tabsorter/addons/pager/jquery.tablesorter.pager.css" rel="stylesheet" media="screen">
        <script src="../bootstrap/js/bootstrap.min.js"></script>
        <script src="../common/xhr.js" ></script>
        <script type="text/javascript" src="../tabsort²er/jquery-latest.js"></script> 
        <script type="text/javascript" src="../tabsorter/jquery.tablesorter.js"></script> 
        <script type="text/javascript" src="../tabsorter/addons/pager/jquery.tablesorter.pager.js"></script> 
        <link rel="StyleSheet" type="text/css" href="../common/page.css" />
    </head>
    <body>
        <?php
        include_once('../common/menu.html');
        include_once('../common/functions.php');

        if (isset($_GET['numcourse'])) {
            $CourseArray = (array) getEditCourse(); // TROP LA CLASSE ^^'
            $ListeCoursesArray = (array) getCourseShortListe();
        }

        function getValue($param, &$array) {
            if (isset($_GET['numcourse'])) {
                echo $array[$param];
            }
        }
        ?>
        <div id="wrapper">
            <center>
                <h2>CONSULTATION DES COURSES</h2>
                <i>Tous les champs doivent être renseignés!</i>
                <form>

                    <table>
                        <tr><th>N°de course</th><th>Année</th><th>Date</th></tr>
                        <tr>
                            <td>
                                <?php
                                if (isset($_GET['numcourse'])) {
                                    echo "<select>";
                                    foreach ($ListeCoursesArray as $row) {
                                        echo "<option value='" . $row->Numcourse . "'>" . $row->AnneeCourse . "</option>";
                                    }
                                    echo "</select>";
                                } else {
                                    echo '<input type="text">';
                                }
                                ?>

                            </td>
                            <td>
                                <input type="text" value="<?php getValue("AnneeCourse", $CourseArray); ?>">
                            </td>
                            <td>
                                <input type="text" value="<?php getValue("DateCourse", $CourseArray); ?>">
                            </td>
                        </tr>
                    </table>   
                    <table>
                        <tr>
                            <th>Circuit 1</th>
                            <th>Circuit 2</th>
                            <th>Circuit 3</th>  
                        </tr>
                        <tr>
                            <td>
                                <input type="text" value="<?php getValue("DistanceC1", $CourseArray); ?>">
                            </td>
                            <td>
                                <input type="text" value="<?php getValue("DistanceC2", $CourseArray); ?>">
                            </td>
                            <td>
                                <input type="text" value="<?php getValue("DistanceC3", $CourseArray); ?>">
                            </td>
                        </tr>
                    </table> 
                    <table>
                        <tr>
                            <th></th>
                            <th>Nombre de participants</th>
                            <th>Nombre de retours</th>
                        </tr>
                        <tr>
                            <td>Circuit 1</td>
                            <td><input type="text" value="<?php getValue("NbParticipantsC1", $CourseArray); ?>"></td>
                            <td><input type="text" value="<?php getValue("NbRetourC1", $CourseArray); ?>"></td>
                        </tr>
                        <tr>
                            <td>Circuit 2</td>
                            <td><input type="text" value="<?php getValue("NbParticipantsC1", $CourseArray); ?>"></td>
                            <td><input type="text" value="<?php getValue("NbRetourC1", $CourseArray); ?>"></td>
                        </tr>
                        <tr>
                            <td>Circuit 3</td>
                            <td><input type="text" value="<?php getValue("NbParticipantsC1", $CourseArray); ?>"></td>
                            <td><input type="text" value="<?php getValue("NbRetourC1", $CourseArray); ?>"></td>
                        </tr>
                        <tr>
                            <td>Total</td>
                            <td><input type="text" value="<?php getValue("NbParticipantsTotal", $CourseArray); ?>"></td>
                            <td><input type="text" value="<?php getValue("NbRetourTotal", $CourseArray); ?>"></td>
                        </tr>
                    </table>
                    <br>
                    <input type="submit" value="Enregistrer les modifications">
                    <input type="button" value="Imprimer" onclick="window.print();">
                    <input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
                </form>
            </center>
        </div>
    </body>
</html>
