
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
<select id='m1' onmouseover="this.size=this.length;" 
 onmouseout="this.size=1;" style="float:left;width:100px;" 
 onchange="document.location=this.value" >
<option value='#'>Acceuil</option>
<option value="index_admin.asp"> > Accueil administrateur</option>
<option value="../default.asp"> > D�connexion</option>

 </select>

 
<select id='m2' onmouseover="this.size=this.length;" 
 onmouseout="this.size=1;" style="width:150px;float:left;" 
 onchange="document.location=this.value" >
 
<option value="#">Gestion de la course</option>
<option value="etat_course.asp"> > etat course</option>
<option value="edit_courses.asp?mode=new"> > Ajouter une course</option>
<option value="start.asp"> > Demarrer la course</option>
<option value="saisie_depart.asp"> > Saisie des d�parts</option>
<option value="saisie_retour.asp"> > Saisie des retours</option>
<option value="cloturer_course.asp"> > Cloturer la course </option>
<option value="stop.asp"> > Arr�ter la course</option>
 </select>
 
   <!-- <ul id="menuList1"> 
     <li><a href="index_admin.asp" class="actuator">Accueil</a></li> 
			<ul class="menu"> 
			<li><a href="index_admin.asp">Accueil administrateur</a></li> 
      <li><a href="../default.asp">D�connexion</a></li> 
   	 </ul>-->
      	
 <!--    <li><a href="#" class="actuator">Gestion de la course</a></li> 
			<ul class="menu"> 
			<li><a href="etat_course.asp">Etat de la course</a></li> 
			<li><a href="#">----------------------------</a></li> 
			<li><a href="edit_courses.asp?mode=new">Ajouter une course</a></li> 
			<li><a href="start.asp">D�marrer la course</a></li> 
			<li><a href="saisie_depart.asp">Saisie des d�parts</a></li> 
			<li><a href="saisie_retour.asp">Saisie des retours</a></li>
			<li><a href="cloturer_course.asp">Cloturer la course</a></li> 
			<li><a href="stop.asp">Arr�ter la course</a></li> 
			<li><a href="#">----------------------------</a></li> 
			<li><a href="rewards.asp">Gestion des r�compenses</a></li>       
    	</ul>  
    	-->
<select id='m3' onmouseover="this.size=this.length;" 
 onmouseout="this.size=1;" style="width:175px;float:left;" 
 onchange="document.location=this.value" >
 
<option value="#">Gestion des courses</option>
<option value="liste_courses.asp"> > Afficher toutes les courses </option>
<option value="edit_courses.asp"> > Modifier une course</option>
<option value="edit_courses.asp?mode=new"> > Ajouter une course</option>



 </select>    
   <!-- 
		<li><a href="#" class="actuator">Gestion des courses</a></li> 
		<ul class="menu"> 
			<li><a href="liste_courses.asp">Afficher toutes les courses</a></li> 
      <li><a href="edit_courses.asp">Modifier une course</a></li>
      <li><a href="edit_courses.asp?mode=new">Ajouter une nouvelle course</a></li> 
    </ul>  
    -->
    <select id='m4' onmouseover="this.size=this.length;" 
 onmouseout="this.size=1;" style="width:170px;float:left;" 
 onchange="document.location=this.value" >
 
<option value="#">Gestion des cyclistes</option>
<option value="liste_cycliste.asp"> > Afficher les cyclistes </option>
<option value="recherche_cycliste.asp"> > Rechercher un cycliste</option>
<option value="edit_cycliste.asp?mode=new"> > Ajouter un nouveau cycliste</option>



 </select>  
   <!-- <li><a href="#" class="actuator">Gestion des cyclistes</a></li> 
		<ul class="menu"> 
			<li><a href="liste_cycliste.asp">Afficher les cyclistes</a></li> 
			<li><a href="recherche_cycliste.asp">Rechercher un cycliste</a></li> 
      <li><a href="edit_cycliste.asp?mode=new">Ajouter un nouveau cycliste</a></li> 
    </ul> -->
     <select id='m5' onmouseover="this.size=this.length;" 
 onmouseout="this.size=1;" style="width:170px;float:left;" 
 onchange="document.location=this.value" >
 
<option value="#">Impression</option>
<option value="liste_cycliste.asp"> > Liste les cyclistes </option>
<option value="recherche_cycliste.asp"> > Liste des courses</option>
<option value="etiquettes.asp?num=1"> > Etiquettes </option>

 </select>  
    
 <!--
    <li><a href="#" class="actuator">Impression</a></li> 
		<ul class="menu"> 
			<li><a href="diplomes.asp">Dipl�mes</a></li> 
			<%
			'if Application("blnBDDOracle")=true then		
				%>
				<li><a href="edit_diplome.asp">Param�trage des Dipl�mes</a></li> 
				<%
			'end if
			%>
      <li><a href="liste_cycliste_total.asp">Liste des cyclistes</a></li> 
      <li><a href="liste_courses.asp">Liste des courses</a></li> 
      <li><a class="actuator" href="#">Etiquettes</a>
      	<ul class="menu"> 
					<li><a href="etiquettes.asp?num=1" target="_blank">Etiquettes cyclistes Format 1</a></li> 
      		<li><a href="etiquettes.asp?num=2" target="_blank">Etiquettes cyclistes Format 2</a></li> 
      		<li><a href="etiquettes.asp?num=3" target="_blank">Etiquettes cyclistes Format 3</a></li> 
      		<li><a href="etiquettes.asp?num=4" target="_blank">Etiquettes cyclistes Format 4</a></li> 
    		</ul>      
      </li> 
      <li><a class="actuator" href="#">Param�trage des Etiquettes</a>
      	<ul class="menu"> 
					<li><a href="edit_etiquettes.asp?num=1">Etiquettes cyclistes Format 1</a></li> 
      		<li><a href="edit_etiquettes.asp?num=2">Etiquettes cyclistes Format 2</a></li> 
      		<li><a href="edit_etiquettes.asp?num=3">Etiquettes cyclistes Format 3</a></li> 
      		<li><a href="edit_etiquettes.asp?num=4">Etiquettes cyclistes Format 4</a></li> 
    		</ul>      
      </li>  
    </ul>  -->
    
      <select id='m6' onmouseover="this.size=this.length;" 
 onmouseout="this.size=1;" style="width:170px;float:left;" 
 onchange="document.location=this.value" >
 
<option value="#">Statistique</option>
<option value="edit_stat.asp"> > Statistique par ann�es </option>
<option value="action_stat2.asp"> > Bilan global </option>
<option value="stat_excel.asp"> > Bilan global (Excel) </option>
<option value="action_stat3.asp"> > Bilan simplif� </option>
<option value="stat_excel2.asp"> >Bilan simplifi� (Excel) </option>

 </select>
  
  
  <!--
     <li><a href="#" class="actuator">Statistiques</a></li> 
		<ul class="menu"> 
			<li><a href="edit_stat.asp">Statistiques par ann�es</a></li> 
			<li><a href="action_stat2.asp">Bilan global</a></li> 
      <li><a href="stat_excel.asp">Bilan global (EXCEL)</a></li>
      <li><a href="action_stat3.asp">Bilan simplifi�</a></li>  
      <li><a href="stat_excel2.asp">Bilan simplifi� (EXCEL)</a></li> 
    </ul>  
    -->
    
   
   
 </div> 

	<select class="menu_item" id='m6' style="position:absolute;width:172px;margin:0 0 0 941px;float:left;" onmouseover="this.size=this.length;" onmouseout="this.size=1;" onchange="document.location=this.value" >
		<option value="#">Statistiques</option>
		<option value=".asp">Statistiques par ann�es</option>
		<option value=".asp">Bilan global</option>
		<option value=".asp">Bilan global (Excel)</option>
		<option value=".asp">Bilan simplifi�</option>
		<option value=".asp">Bilan simplifi� (Excel)</option>
	</select>
	<span class="menu_item" id='info_course' style="position:absolute;width:auto;margin:0 0 0 1123px;float:left;">
		Une course en cours
	</span>
</div> 
<% 
end sub
%>
