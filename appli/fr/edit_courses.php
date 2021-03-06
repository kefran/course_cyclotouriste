<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <title>Site des gestion de la course de la LIONNE</title>
        <link href="../style.css" rel="stylesheet" type="text/css">
        <link href="../bootstrap/css/bootstrap.min.ie.css" rel="stylesheet" media="screen">
        <link href="../tabsorter/addons/pager/jquery.tablesorter.pager.css" rel="stylesheet" media="screen">
        <script src="../bootstrap/js/bootstrap.min.js"></script>
        <script src="../common/xhr.js" ></script>
        <script type="text/javascript" src="../jquery.js"></script> 
        <script type="text/javascript" src="../tabsorter/jquery.tablesorter.js"></script> 
        <script type="text/javascript" src="../tabsorter/addons/pager/jquery.tablesorter.pager.js"></script> 
        <script type="text/javascript" src="../datepicker/js/bootstrap-datepicker.js"></script> 
        <link rel="StyleSheet" type="text/css" href="../datepicker/css/datepicker.css" />
        <link rel="StyleSheet" type="text/css" href="../common/page.css" />

    </head>
    <body>
        <?php
        include_once('../common/menu.html');
        include_once('../common/functions.php');

        if (isset($_GET['numcourse'])) {
            $CourseArray = (array) getEditCourse($_GET['numcourse']); // TROP LA CLASSE ^^'
            $ListeCoursesArray = (array) getCourseShortListe();
        }

        function getValue($param, &$array) {
            if (isset($_GET['numcourse'])) {
                return $array[$param];
            } else
                return "";
        }
        ?>
        <div id="wrapper">
            <center>
                <?php
                if (isset($_GET['numcourse'])) {
                    echo " <h2>Consultation des courses</h2>";
                } else {
                    echo "<h2>Ajouter une course</h2>";
                }
                ?>
                <div class="alert hide alert-danger  champsvides ">
                    <i class="icon-exclamation-sign"></i><strong> Tous les champs doivent �tre renseign�s! </strong>
                </div>
                <div class="alert hide alert-warning  annee ">
                    <i class="icon-exclamation-sign"></i><strong>Il existe d�j� une course pour cette ann�e!</strong>
                </div>
                <div class="alert hide alert-danger  type ">
                    <i class="icon-exclamation-sign"></i><strong> Veillez � bien remplire les champs </strong>
                </div>
                <div class="alert hide alert-success  modif text-center">
                    <i class="icon-exclamation-sign"></i><strong>Les modifications ont �t� enregistr�es</strong>
                </div>
                <div class="alert hide alert-success  ajout text-center">
                    <i class="icon-exclamation-sign"></i><strong>La course a �t� enregistr�e</strong>
                </div>
                <form method="POST" id="FrmEditCourse" action="./action_edit_course.php">
                    <br>
                    <input id="type" name="type" type="hidden" value="<?php
                    if (isset($_GET['numcourse'])) {
                        echo "edit";
                    } else {
                        echo "new";
                    }
                    ?>">
                    <table>
                        <tr><th>N�de course</th><th>Date <i>(mm/jj/aaaa)</i></th><th>Ann�e</th></tr>
                        <tr>
                            <td>
                                <?php
                                if (isset($_GET['numcourse'])) {
                                    echo "<select onchange='ChangeCourse();' id='NumCourse' name='NumCourse'>";
                                    foreach ($ListeCoursesArray as $row) {
                                        if ($row->Numcourse == $_GET['numcourse']) {
                                            echo "<option  selected='selected' value='" . $row->Numcourse . "'>" . $row->Numcourse . " (" . $row->AnneeCourse . ")</option>";
                                        } else {
                                            echo "<option  value='" . $row->Numcourse . "'>" . $row->Numcourse . " (" . $row->AnneeCourse . ")</option>";
                                        }
                                    }
                                    echo "</select>";
                                } else {
                                    echo '<input type="text" value="' . getLastcourseId() . '" disabled>'
                                    . '<input id="NumCourse" name="NumCourse" type="hidden" value="' . getLastcourseId() . '">';
                                }
                                ?>

                            </td>
                            <td>
                                <div class="input-append date" id="dp1">
                                    <input  onchange="setYear();" id="DateCourse" name="DateCourse"  size="100" type="text" value="<?php
                                    if (isset($_GET['numcourse'])) {
                                        echo date_format(date_create(getValue("DateCourse", $CourseArray)), "d/m/Y");
                                    }
                                    ?>">
                                    <span class="add-on"><i class="icon-th"></i></span>
                                </div>
                            </td>
                            <td>
                                <input id="AnneeCourse" name="AnneeCourse" type="text" value="<?php echo getValue("AnneeCourse", $CourseArray); ?>">

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
                                <input id="DistanceC1" name="DistanceC1" type="text" value="<?php echo getValue("DistanceC1", $CourseArray); ?>">
                            </td>
                            <td>
                                <input id="DistanceC2" name="DistanceC2" type="text" value="<?php echo getValue("DistanceC2", $CourseArray); ?>">
                            </td>
                            <td>
                                <input id="DistanceC3" name="DistanceC3" type="text" value="<?php echo getValue("DistanceC3", $CourseArray); ?>">
                            </td>
                        </tr>
                    </table> 
                    <?php
                    if (isset($_GET["numcourse"])) {
                        ?>
                        <table>
                            <tr>
                                <th></th>
                                <th>Nombre de participants</th>
                                <th>Nombre de retours</th>
                            </tr>
                            <tr>
                                <td>Circuit 1</td>
                                <td><input disabled type="text" value="<?php echo getValue("NbParticipantsC1", $CourseArray); ?>"></td>
                                <td><input disabled type="text" value="<?php echo getValue("NbRetourC1", $CourseArray); ?>"></td>
                            </tr>
                            <tr>
                                <td>Circuit 2</td>
                                <td><input disabled type="text" value="<?php echo getValue("NbParticipantsC1", $CourseArray); ?>"></td>
                                <td><input disabled type="text" value="<?php echo getValue("NbRetourC1", $CourseArray); ?>"></td>
                            </tr>
                            <tr>
                                <td>Circuit 3</td>
                                <td><input disabled type="text" value="<?php echo getValue("NbParticipantsC1", $CourseArray); ?>"></td>
                                <td><input disabled type="text" value="<?php echo getValue("NbRetourC1", $CourseArray); ?>"></td>
                            </tr>
                            <tr>
                                <td>Total</td>
                                <td><input disabled type="text" value="<?php echo getValue("NbParticipantsTotal", $CourseArray); ?>"></td>
                                <td><input disabled type="text" value="<?php echo getValue("NbRetourTotal", $CourseArray); ?>"></td>
                            </tr>
                        </table>
                        <?php
                    }
                    ?>
                    <br>
                    <input type="submit" value="Enregistrer les modifications">
                    <input type="button" value="Imprimer" onclick="window.print();">
                    <input type="button" value="Retour � l'accueil" onclick="window.location.replace('index_admin.asp');">
                </form>
            </center>
        </div>
        <script>
            function ChangeCourse() {
                location.replace("./edit_courses.php?numcourse=" + $('#NumCourse').val());
            }
            ;
            function setYear() {
                var aa = $('#DateCourse').val();
                $("#AnneeCourse").val((aa.substring(6, 10)));
            }

            $().ready(function() {


                $('#dp1').datepicker({
                    weekStart: 1,
                    autoclose: true,
                    keyboardNavigation: true,
                    format: 'dd/mm/yyyy'
                });
                $('#FrmEditCourse').on('submit', function() {
                    var type = $('#type').val();
                    var NumCourse = $('#NumCourse').val();
                    var DateCourse = $('#DateCourse').val();
                    var AnneeCourse = $('#AnneeCourse').val();
                    var DistanceC1 = $('#DistanceC1').val();
                    var DistanceC2 = $('#DistanceC2').val();
                    var DistanceC3 = $('#DistanceC3').val();
                    if (NumCourse === '' || DateCourse === '' || DistanceC1 === '' || DistanceC2 === '' || DistanceC3 === '')
                    {
                        $('.champsvides').show("slow");
                        window.setTimeout(function() {
                            $('.champsvides').hide("slow");
                        }, 3000);

                    }
                    else
                    {
                        if ($.isNumeric(AnneeCourse) && $.isNumeric(DistanceC1) && $.isNumeric(DistanceC2) && $.isNumeric(DistanceC3))
                        {
                            $.ajax({
                                url: $(this).attr('action'),
                                type: $(this).attr('method'),
                                data: $(this).serialize(),
                                dataType: 'json',
                                success: function(json) {
                                    if (json.reponse === 'modif') {
                                        $('.modif').show("slow");
                                        window.setTimeout(function() {
                                            location.reload();
                                        }, 1500);
                                    } else {
                                        if (json.reponse === 'ajout')
                                        {
                                            $('.ajout').show("slow");
                                            window.setTimeout(function() {
                                                ocation.reload();
                                            }, 1500);
                                        }
                                        else
                                        {
                                            if (json.reponse === 'existe')
                                            {
                                                $('.annee').show("slow");
                                                window.setTimeout(function() {
                                                    $('.annee').hide("slow");
                                                }, 3000);
                                            }
                                            else
                                            {
                                                alert("Une erreur est survenue");
                                            }
                                        }
                                    }
                                }
                            });
                        }
                        else
                        {
                            $('.type').show("slow");
                            window.setTimeout(function() {
                                $('.type').hide("slow");
                            }, 3000);
                        }
                    }
                    return false;
                });
            });
        </script>
    </body>
</html>
