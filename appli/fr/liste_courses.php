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
        <link rel="StyleSheet" type="text/css" href="../common/page.css" />
    </head>
    <body>
        <?php include_once('../common/menu.html'); ?>
        <?php include_once('../common/functions.php'); ?>
        <div id="wrapper">
            <h2> Listes des courses </h2>
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
