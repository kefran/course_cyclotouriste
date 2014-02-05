<% sub menu_head() %>
	<meta http-equiv="X-UA-Compatible" content="IE=8">
	<title>Site des gestion de la course de la LIONNE</title>
	<link href="../style.css" rel="stylesheet" type="text/css">
	<link href="../bootstrap/css/bootstrap.min.ie.css" rel="stylesheet" media="screen">
	<script src="http://code.jquery.com/jquery.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
	<script src="../common/xhr.js" ></script>
	<link rel="StyleSheet" type="text/css" href="../common/page.css" />
	<link rel="StyleSheet" type="text/css" href="../common/menuH.css" title="Horizontal" />
	<link rel="Alternate StyleSheet" type="text/css" href="../common/menuV.css" title="Vertical" />
<% 
end sub

sub menu()
 %>
<div id="mainMenu1">
<ul>
	<li>
<select id='m1' onmouseover="this.size=this.length;" onmouseout="this.size=1;" onchange="document.location=this.value" >
	<option value='#'>Acceuil</option>
	<option value="index_admin.asp"> > Accueil administrateur</option>
	<option value="../default.asp"> > Déconnexion</option>
	</select>
 	</li>
 	<li>
<select id='m2' onmouseover="this.size=this.length;" onmouseout="this.size=1;" onchange="document.location=this.value" >
	<option value="#">Gestion de la course</option>
	<option value="etat_course.asp"> > etat course</option>
	<option value="edit_courses.asp?mode=new"> > Ajouter une course</option>
	<option value="start.asp"> > Demarrer la course</option>
	<option value="saisie_depart.asp"> > Saisie des départs</option>
	<option value="saisie_retour.asp"> > Saisie des retours</option>
	<option value="cloturer_course.asp"> > Cloturer la course </option>
	<option value="stop.asp"> > Arrêter la course</option>
 </select>
 
 </li>
 	<li>
	<select id='m3' onmouseover="this.size=this.length;" onmouseout="this.size=1;"  onchange="document.location=this.value" >
		<option value="#">Gestion des courses</option>
		<option value="liste_course.asp"> > Afficher toutes les courses </option>
		<option value="edit_courses.asp"> > Modifier une course</option>
		<option value="edit_courses.asp?mode=new"> > Ajouter une course</option>
	</select>    
	</li>
 	<li>
	<select id='m4' onmouseover="this.size=this.length;" onmouseout="this.size=1;" onchange="document.location=this.value" >
		<option value="#">Gestion des cyclistes</option>
		<option value="liste_cycliste.asp"> > Afficher les cyclistes </option>
		<option value="recherche_cycliste.asp"> > Rechercher un cycliste</option>
		<option value="edit_cycliste.asp?mode=new"> > Ajouter un nouveau cycliste</option>
	</select>
	</li>
 	<li>
	<select id='m5' onmouseover="this.size=this.length;" onmouseout="this.size=1;" onchange="document.location=this.value" >
		<option value="#">Impression</option>
		<option value="diplomes.asp">Diplômes</option>
		<option value="edit_diplome.asp"> > Rechercher un cycliste</option>
		<option value="liste_cycliste_total.asp">Liste des cyclistes</option>
		<option value="liste_courses.asp">Liste des courses</option>
		<option value="etiquettes.asp?num=1">Etiquettes</option>
		<option value="edit_etiquettes.asp?num=1">Modifier les Etiquettes</option>
	</select>
	</li>
 	<li>
	<select id='m6' onmouseover="this.size=this.length;" onmouseout="this.size=1;" onchange="document.location=this.value" >
		<option value="#">Statistiques</option>
		<option value=".asp">Statistiques par années</option>
		<option value=".asp">Bilan global</option>
		<option value=".asp">Bilan global (Excel)</option>
		<option value=".asp">Bilan simplifié</option>
		<option value=".asp">Bilan simplifié (Excel)</option>
	</select>
	</li>
 	</ul>
</div> 
<% 
end sub
%>