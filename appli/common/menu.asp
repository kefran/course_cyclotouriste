<%
sub menu_head()

 %>

	  <link rel="StyleSheet" type="text/css" href="../common/page.css" />
    <link rel="StyleSheet" type="text/css" href="../common/menuH.css" title="Horizontal" />
    <link rel="Alternate StyleSheet" type="text/css" href="../common/menuV.css" title="Vertical" />
	  <script type="text/javascript" src="../common/menuDropdown.js"></script>

<% 

end sub

sub menu()


 %>
<div id="mainMenu1"> 
    <ul id="menuList1"> 
     <li><a href="index_admin.asp" class="actuator">Accueil</a></li> 
			<ul class="menu"> 
			<li><a href="index_admin.asp">Accueil administrateur</a></li> 
      <li><a href="../default.asp">D�connexion</a></li> 
   	 </ul>
      	
     <li><a href="#" class="actuator">Gestion de la course</a></li> 
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
    
    
		<li><a href="#" class="actuator">Gestion des courses</a></li> 
		<ul class="menu"> 
			<li><a href="liste_courses.asp">Afficher toutes les courses</a></li> 
      <li><a href="edit_courses.asp">Modifier une course</a></li>
      <li><a href="edit_courses.asp?mode=new">Ajouter une nouvelle course</a></li> 
    </ul>  
    
    
    <li><a href="#" class="actuator">Gestion des cyclistes</a></li> 
		<ul class="menu"> 
			<li><a href="liste_cycliste.asp">Afficher les cyclistes</a></li> 
			<li><a href="recherche_cycliste.asp">Rechercher un cycliste</a></li> 
      <li><a href="edit_cycliste.asp?mode=new">Ajouter un nouveau cycliste</a></li> 
    </ul> 
    
    
    
   
    
    
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
    </ul>  
    
 
   <li><a href="#" class="actuator">Statistiques</a></li> 
		<ul class="menu"> 
			<li><a href="edit_stat.asp">Statistiques par ann�es</a></li> 
			<li><a href="action_stat2.asp">Bilan global</a></li> 
      <li><a href="stat_excel.asp">Bilan global (EXCEL)</a></li>
      <li><a href="action_stat3.asp">Bilan simplifi�</a></li>  
      <li><a href="stat_excel2.asp">Bilan simplifi� (EXCEL)</a></li> 
    </ul>  
    
          
	
			
		
	  
      
 </div> 

<% 

end sub
%>