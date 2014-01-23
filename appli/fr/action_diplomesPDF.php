<?
//******************************************
//Par Julien LAB et Valentin BIAUZON 2004
//******************************************
//
//Impression de diplomes au format PDF (script PHP)
//
//******************************************
?>

<?
define('FPDF_FONTPATH','../common/fpdf/font/');
require('../common/fpdf/fpdf.php');

$bd="lionne"; // identifiant dsn
$user=""; // login    
$password=""; // password   
$cnx = odbc_connect( $bd , $user, $password );
if( ! $cnx ) 
	{
	echo "Impossible de se connecter";
	die;
	}
	
if ($_GET['mode']=="unique")
{	
	
	$intNumcyc=$_GET['numcyc'];
	
	if ($intNumcyc==0)
		die("Aucun cycliste sélectionné!");
	
	//On récupère les données du cycliste
	$strSQL="SELECT * FROM CYCLISTE WHERE NUMCYC=". $intNumcyc;
	
	$result=odbc_exec($cnx,$strSQL);
	if ($result==FALSE) 
		die("Erreur lors du chargement des données concernant le cycliste");
	$line=odbc_fetch_array($result);
	$strNom=$line['NOM'];
	$strPrenom=$line['PRENOM'];
	$strPolit=$line['POLIT'];
	$strNbcourses=$line['NBCOURSES'];
	if ($strNbcourses==1)
	{
		$strNbcourses="1ère";
	}
	else
	{
		$strNbcourses=$strNbcourses."ème";
	}
	
	odbc_free_result($result);
	
	//On récupère le numéro de course courant
	$strSQL="SELECT Max(numcourse) AS NB FROM COURSE";
	$result=odbc_exec($cnx,$strSQL);
	if ($result==FALSE) 
		die("Erreur lors du chargement du numéro de la dernière course");
	$line=odbc_fetch_array($result);
	$intNumcourse=$line['NB'];
	odbc_free_result($result);	
		
	//On trouve à quelle course la personne a participé
	$strSQL="SELECT NUMCIRCUIT FROM PARTICIPER WHERE NUMCOURSE=".$intNumcourse." AND NUMCYC=".$intNumcyc;
	$result=odbc_exec($cnx,$strSQL);
	if ($result==FALSE) 
		die("Erreur lors du chargement du numéro de circuit auquel le coureur a participé");
	$line=odbc_fetch_array($result);
	$intNumcircuit=$line['NUMCIRCUIT'];
	odbc_free_result($result);
	
	//On récupère les infos sur la course courante
	$strSQL="SELECT DATECOURSE,ANNEECOURSE,DISTANCEC".$intNumcircuit." AS KM FROM COURSE WHERE NUMCOURSE=".$intNumcourse;
	$result=odbc_exec($cnx,$strSQL);
	if ($result==FALSE) 
		die("Erreur lors du chargement des données de la course");
	$line=odbc_fetch_array($result);
	$strDistance=$line['KM'];
	$strAnneecourse=$line['ANNEECOURSE'];
	$strDatecourse=$line['DATECOURSE'];
	odbc_free_result($result);
	
	
	//On met correctement en forme (à la française) la date
	$strDatecourse=substr($strDatecourse,5,2)."/".substr($strDatecourse,8,2)."/".substr($strDatecourse,0,4);
	
	include './configPDF.php';
	$pdf=new FPDF();
	$pdf->AddPage("L");
	$pdf->SetFont("Arial","",12);
	$pdf->Ln($nb_lignes_blanches_depuis_haut);
	$pdf->SetFont("Arial","B",14);
	$pdf->Write(5,$ligne1);
	$pdf->Ln($nb_lignes_blanches_entre_l1_et_l2);
	$pdf->SetFont("Arial","",12);
	$pdf->Write(5,$ligne2);
	$pdf->Ln($nb_lignes_blanches_entre_l2_et_l3);
	$pdf->Write(5,$ligne3);
		
	
	//Détermination d'un nom de fichier temporaire dans le répertoire courant
	$file=basename(tempnam(getcwd(),'tmp'));
	//Sauvegarde du PDF dans le fichier
	$pdf->Output($file);
	//Redirection JavaScript
	echo "<HTML><SCRIPT>document.location='getpdf.php?f=$file';</SCRIPT></HTML>"; 
}

elseif ($_GET['mode']=="tous")
{
	//On doit générer un PDF contenant TOUS les Diplômes
	$pdf=new FPDF();
	
	//On récupère le numéro de course courant
	$strSQL="SELECT Max(numcourse) AS NB FROM COURSE";
	$result=odbc_exec($cnx,$strSQL);
	if ($result==FALSE) 
		die("Erreur lors du chargement du numéro de la dernière course");
	$line=odbc_fetch_array($result);
	$intNumcourse=$line['NB'];
	odbc_free_result($result);	
	
	//On récupère tous les numéros de cyclistes concernés par les diplomes
	$strSQL="Select NOM,PRENOM,POLIT,NBCOURSES,CYCLISTE.NUMCYC FROM CYCLISTE,PARTICIPER WHERE CYCLISTE.NUMCYC=PARTICIPER.NUMCYC AND PARTICIPER.HDEPART IS NOT NULL AND PARTICIPER.NUMCOURSE=".$intNumcourse." ORDER BY CYCLISTE.NOM,CYCLISTE.PRENOM,CYCLISTE.NUMCYC ASC";
	$result2=odbc_exec($cnx,$strSQL);
	if ($result2==FALSE) 
		die("Erreur de connexion à la Base de Données");
	//On boucle sur tous les cyclistes
	while ($line2 = odbc_fetch_array($result2)) {
			$intNumcyc=$line2['NUMCYC'];			
			$strNom=$line2['NOM'];
			$strPrenom=$line2['PRENOM'];
			$strPolit=$line2['POLIT'];
			$strNbcourses=$line2['NBCOURSES'];
			if ($strNbcourses==1)
			{
				$strNbcourses="1ère";
			}
			else
			{
				$strNbcourses=$strNbcourses."ème";
			}
						
			//On trouve à quelle course la personne a participé
			$strSQL="SELECT NUMCIRCUIT FROM PARTICIPER WHERE NUMCOURSE=".$intNumcourse." AND NUMCYC=".$intNumcyc;
			$result=odbc_exec($cnx,$strSQL);
			if ($result==FALSE) 
				die("Erreur lors du chargement du numéro de circuit auquel le coureur a participé");
			$line=odbc_fetch_array($result);
			$intNumcircuit=$line['NUMCIRCUIT'];
			odbc_free_result($result);
			
			//On récupère les infos sur la course courante
			$strSQL="SELECT DATECOURSE,ANNEECOURSE,DISTANCEC".$intNumcircuit." AS KM FROM COURSE WHERE NUMCOURSE=".$intNumcourse;
			$result=odbc_exec($cnx,$strSQL);
			if ($result==FALSE) 
				die("Erreur lors du chargement des données de la course");
			$line=odbc_fetch_array($result);
			$strDistance=$line['KM'];
			$strAnneecourse=$line['ANNEECOURSE'];
			$strDatecourse=$line['DATECOURSE'];
			odbc_free_result($result);
			
			
			//On met correctement en forme (à la française) la date
			$strDatecourse=substr($strDatecourse,5,2)."/".substr($strDatecourse,8,2)."/".substr($strDatecourse,0,4);
			
			//On écrit la page
			include './configPDF.php';
			$pdf->AddPage("L");
			$pdf->SetFont("Arial","",12);
			$pdf->Ln($nb_lignes_blanches_depuis_haut);
			$pdf->SetFont("Arial","B",14);
			$pdf->Write(5,$ligne1);
			$pdf->Ln($nb_lignes_blanches_entre_l1_et_l2);
			$pdf->SetFont("Arial","",12);
			$pdf->Write(5,$ligne2);
			$pdf->Ln($nb_lignes_blanches_entre_l2_et_l3);
			$pdf->Write(5,$ligne3);
	
	}

	
	//Détermination d'un nom de fichier temporaire dans le répertoire courant
	$file=basename(tempnam(getcwd(),'tmp'));
	//Sauvegarde du PDF dans le fichier
	$pdf->Output($file);
	//Redirection JavaScript
	echo "<HTML><SCRIPT>document.location='getpdf.php?f=$file';</SCRIPT></HTML>"; 
	
	
}
elseif ($_GET['mode']=="non_rentres")
{
	//On doit générer un PDF contenant TOUS les Diplômes
	$pdf=new FPDF();
	
	//On récupère le numéro de course courant
	$strSQL="SELECT Max(numcourse) AS NB FROM COURSE";
	$result=odbc_exec($cnx,$strSQL);
	if ($result==FALSE) 
		die("Erreur lors du chargement du numéro de la dernière course");
	$line=odbc_fetch_array($result);
	$intNumcourse=$line['NB'];
	odbc_free_result($result);	
	
	//On récupère tous les numéros de cyclistes concernés par les diplomes
	$strSQL="SELECT NOM,PRENOM,POLIT,NUMCYC,NBCOURSES FROM CYCLISTE WHERE DERNUMCOURSE=".$intNumcourse." AND DEPART <>0 AND( RETOUR IS NULL OR RETOUR=0) ORDER BY NOM,PRENOM,NUMCYC ASC";
	//$strSQL="Select NOM,PRENOM,POLIT,CYCLISTE.NUMCYC FROM CYCLISTE,PARTICIPER WHERE CYCLISTE.NUMCYC=PARTICIPER.NUMCYC AND PARTICIPER.HDEPART IS NOT NULL AND PARTICIPER.NUMCOURSE=".$intNumcourse." ORDER BY CYCLISTE.NOM,CYCLISTE.PRENOM,CYCLISTE.NUMCYC ASC";
	$result2=odbc_exec($cnx,$strSQL);
	if ($result2==FALSE) 
		die("Erreur de connexion à la Base de Données");
		
	//On boucle sur tous les cyclistes
	//Si aucun cycliste, on le marque
	if (odbc_num_rows($result2)==0)
	{
			//On écrit la page
				$pdf->AddPage("L");
				$pdf->SetFont("Arial","",12);
				$pdf->Ln(128);
				$pdf->Write(5,"Tous les cyclistes sont rentrés!");
				
		
	}
	else
	{
		while ($line2 = odbc_fetch_array($result2)) {
				$intNumcyc=$line2['NUMCYC'];			
				$strNom=$line2['NOM'];
				$strPrenom=$line2['PRENOM'];
				$strPolit=$line2['POLIT'];
				$strNbcourses=$line2['NBCOURSES'];
				if ($strNbcourses==1)
				{
					$strNbcourses="1ère";
				}
				else
				{
					$strNbcourses=$strNbcourses."ème";
				}
							
				//On trouve à quelle course la personne a participé
				$strSQL="SELECT NUMCIRCUIT FROM PARTICIPER WHERE NUMCOURSE=".$intNumcourse." AND NUMCYC=".$intNumcyc;
				$result=odbc_exec($cnx,$strSQL);
				if ($result==FALSE) 
					die("Erreur lors du chargement du numéro de circuit auquel le coureur a participé");
				$line=odbc_fetch_array($result);
				$intNumcircuit=$line['NUMCIRCUIT'];
				odbc_free_result($result);
				
				//On récupère les infos sur la course courante
				$strSQL="SELECT DATECOURSE,ANNEECOURSE,DISTANCEC".$intNumcircuit." AS KM FROM COURSE WHERE NUMCOURSE=".$intNumcourse;
				$result=odbc_exec($cnx,$strSQL);
				if ($result==FALSE) 
					die("Erreur lors du chargement des données de la course");
				$line=odbc_fetch_array($result);
				$strDistance=$line['KM'];
				$strAnneecourse=$line['ANNEECOURSE'];
				$strDatecourse=$line['DATECOURSE'];
				odbc_free_result($result);
				
				
				//On met correctement en forme (à la française) la date
				$strDatecourse=substr($strDatecourse,5,2)."/".substr($strDatecourse,8,2)."/".substr($strDatecourse,0,4);
				
				//On écrit la page
				include './configPDF.php';
	
				$pdf->AddPage("L");
				$pdf->SetFont("Arial","",12);
				$pdf->Ln($nb_lignes_blanches_depuis_haut);
				$pdf->SetFont("Arial","B",14);
				$pdf->Write(5,$ligne1);
				$pdf->Ln($nb_lignes_blanches_entre_l1_et_l2);
				$pdf->SetFont("Arial","",12);
				$pdf->Write(5,$ligne2);
				$pdf->Ln($nb_lignes_blanches_entre_l2_et_l3);
				$pdf->Write(5,$ligne3);
				
		
		}
	}

	
	//Détermination d'un nom de fichier temporaire dans le répertoire courant
	$file=basename(tempnam(getcwd(),'tmp'));
	//Sauvegarde du PDF dans le fichier
	$pdf->Output($file);
	//Redirection JavaScript
	echo "<HTML><SCRIPT>document.location='getpdf.php?f=$file';</SCRIPT></HTML>"; 
		
}
else
{
	echo "Erreur de paramètre";
	die;
}


?>

