<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <title>Site des gestion de la course de la LIONNE</title>
        <link href="../style.css" rel="stylesheet" type="text/css">
        <link href="../bootstrap/css/bootstrap.min.ie.css" rel="stylesheet" media="screen">
        <link href="../tabsorter/addons/pager/jquery.tablesorter.pager.css" rel="stylesheet" media="screen">
        <script src="../bootstrap/js/bootstrap.min.js"></script>
        <script src="../common/xhr.js" ></script>
        <script type="text/javascript" src="../tabsorter/jquery-latest.js"></script> 
        <script type="text/javascript" src="../tabsorter/jquery.tablesorter.js"></script> 
        <script type="text/javascript" src="../tabsorter/addons/pager/jquery.tablesorter.pager.js"></script> 
        
        <script> 
        function  getCycliste(el)
        {
        	window.location="./liste_courses.php?numCyc="+el;
        }
        
        
         </script>
        <link rel="StyleSheet" type="text/css" href="../common/page.css" />
    </head>
    <body>
        <?php include_once('../common/menu.html'); ?>
        <?php include_once('../common/functions.php'); ?>
        <div id="wrapper">
            <h2> Listes des courses </h2>
            <b>
		N° de cycliste:&nbsp;</b>
		<input type="text" AUTOCOMPLETE='OFF' style="position:relative;"name="num" id="num"  onkeyup="getCyclistes(this);"
		value ="<?php echo (isset($_GET["numCyc"]))?$_GET["numCyc"]:"";  ?>" />
		
		<div id="autocomp" name="autocomp" class="autocomp"></div>
            <center>
                <table id="liste_course" class="tablesorter table table-bordered">
                    <thead>
                        <tr>
                            <th>Numéro</th>
                            <th>Date</th>
                            <th>Année</th>
                            <th>Total</th>
                            <th>Circuit 1</th>
                            <th>Circuit 2</th>
                            <th>Circuit 3</th>
                            <th></th>
                        </tr> 
                    </thead>
                    <tbody>
                        <?php getCourseListe(); ?>
                    </tbody>
                </table>
            </center>
        </div>  
        <script>
            $(document).ready(function()
            {
                $("#liste_course").tablesorter({
                    headers: {
                        7: {
                            sorter: false}
                    }
                });
            });
        </script>   
    </body>
</html>
