<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <title>Site des gestion de la course de la LIONNE</title>
        <link href="../style.css" rel="stylesheet" type="text/css">
        <link href="../bootstrap/css/bootstrap.min.ie.css" rel="stylesheet" media="screen">
        <script src="http://code.jquery.com/jquery.js"></script>
        <script src="../bootstrap/js/bootstrap.min.js"></script>
        <script src="../common/xhr.js" ></script>
        <link rel="StyleSheet" type="text/css" href="../common/page.css" />
    </head>
    <body>
        <?php include_once('../common/menu.html'); ?>
        <?php include_once('../common/functions.php'); ?>
        <div id="wrapper">
            <h2> Listes des courses </h2>
            <table id="liste_course" class="table table-bordered">
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
                <?php getCourseListe(); ?>
            </table>
        </div>  
    </body>
</html>
