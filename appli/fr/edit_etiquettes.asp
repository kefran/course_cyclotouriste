<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Formatage des étiquettes
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


Dim rsEtiquette
set rsEtiquette = Server.CreateObject("ADODB.recordset")

Dim intNumEtiq
Dim strSQL
If request.querystring("NUM")="1" then
	intNumEtiq=1
	strSQL="SELECT ETIQUETTE1 AS ETIQ FROM ETIQUETTE WHERE ID=1"
elseif request.querystring("NUM")="2" then
	intNumEtiq=2
	strSQL="SELECT ETIQUETTE2 AS ETIQ FROM ETIQUETTE WHERE ID=1"
elseif request.querystring("NUM")="3" then
	intNumEtiq=3
	strSQL="SELECT ETIQUETTE3 AS ETIQ FROM ETIQUETTE WHERE ID=1"
elseif request.querystring("NUM")="4" then
	intNumEtiq=4
	strSQL="SELECT ETIQUETTE4 AS ETIQ FROM ETIQUETTE WHERE ID=1"
else
	Session("strError")="Paramètre des étiquettes à éditer incorrect!"
	response.redirect "index_admin.asp"
end if


rsEtiquette.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
if rsEtiquette.EOF then
	Session("strError")="Impossible charger les données concernant les etiquettes!"
	response.redirect "index_admin.asp"
end if

%>

<html>



<script>
var g_posCurseur; // variable global positition du curseur

//définit la postition du curseur
function setPosCurseurTitre() {
  g_posCurseur = getPosCurseurTitre(mForm.titre);
}

//retourne l'emplacement du curseur
function getPosCurseurTitre(oTextArea) {
  //sauve le contenu avant modification de la zone de texte
  var sAncienTexte = oTextArea.value;

  //crer un objet "Range Objet" et sauve son texte avant modification
  var oRange = document.selection.createRange();
  var sAncRangeTexte = oRange.text;
  //cette chaine ne doit pas se retrouver dans la zone de texte !
  var sMarquer = String.fromCharCode(28)+String.fromCharCode(29)+String.fromCharCode(30);

  //insère la chaine où le curseur est
  oRange.text = sAncRangeTexte + sMarquer; oRange.moveStart('character', (0 - sAncRangeTexte.length - sMarquer.length));

  //sauver la nouvelle chaine
  var sNouvTexte = oTextArea.value;

  //remet la valeur du texte à son ancienne valeur
  oRange.text = sAncRangeTexte;

  //recherche dans la nouvelle chaine et trouve l'emplacement
  // de la chaîne de marquage et renvoie la position
  for (i=0; i <= sNouvTexte.length; i++) {
    var sTemp = sNouvTexte.substring(i, i + sMarquer.length);
    if (sTemp == sMarquer) {
      var cursorPos = (i - sAncRangeTexte.length);
      return cursorPos;
    }
  }
}

//insère la chaine dans la zone de texte où le curseur est
function insereChaineTitre(sChaine) {  
  //si curseur n'a pas de position : insère la chaine à la fin
  if (typeof(g_posCurseur)=='undefined') {
    mForm.titre.value+=sChaine;
  }else {
    var firstPart = mForm.titre.value.substring(0, g_posCurseur);  
    var secondPart = mForm.titre.value.substring(g_posCurseur,mForm.titre.value.length);
    mForm.titre.value = firstPart + sChaine + secondPart;
  }
}



</script> 

<SCRIPT language="javascript">
function ValiderTexte() {
   
   document.mForm.titre.value=escape(document.mForm.titre.value);
   return true;
     
}

</SCRIPT>


<script type="text/javascript">
function load()
{
	mForm.titre.focus();
}
</script>

<% call menu_head %>


<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>
<center>

<h1>EDITION DU FORMAT DES ETIQUETTES <% =intNumetiq %></h1>


<%
' Affichage de l'erreur le cas échéant

if Session("strError")<>"" then
%>
<br>
<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>
<br><br>

<% end if 
Session("strError")="" %>
<br>




<br><br>
<form name="mForm" action="action_edit_etiquettes.asp?num=<% =intNumetiq %>" method="post" onSubmit="return ValiderTexte();">
<input type="button" value="Gras" onclick="insereChaineTitre('[gras][/gras]');">
<input type="button" value="Italique" onclick="insereChaineTitre('[italique][/italique]');">
<input type="button" value="Titre" onclick="insereChaineTitre('[titre][/titre]');">
<input type="button" value="Retour ligne" onclick="insereChaineTitre('[retour_ligne]');">
<input type="button" value="Espace" onclick="insereChaineTitre('[espace]');">
<input type="button" value="Tabulation" onclick="insereChaineTitre('[tabulation]');">
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value="Politesse" onclick="insereChaineTitre('[politesse]');">
<input type="button" value="Prénom" onclick="insereChaineTitre('[prenom]');">
<input type="button" value="Nom" onclick="insereChaineTitre('[nom]');">
<input type="button" value="Adresse" onclick="insereChaineTitre('[adresse]');">
<input type="button" value="Ville" onclick="insereChaineTitre('[ville]');">
<input type="button" value="Code Postal" onclick="insereChaineTitre('[code_postal]');">
<br><br>
<input type="button" value="Numéro Cycliste" onclick="insereChaineTitre('[numcyc]');">
<input type="button" value="Date Naissance" onclick="insereChaineTitre('[date_naissance]');">
<input type="button" value="Partic" onclick="insereChaineTitre('[partic]');">
<input type="button" value="Dernier Num Course" onclick="insereChaineTitre('[der_num_course]');">
<input type="button" value="Dernière Année Course" onclick="insereChaineTitre('[der_annee_course]');">
<input type="button" value="KM Effectués" onclick="insereChaineTitre('[km]');">
<input type="button" value="Nombre de Courses" onclick="insereChaineTitre('[nb_courses]');">

<input type="button" value="Catégorie" onclick="insereChaineTitre('[categorie]');">
<input type="button" value="ASCAP" onclick="insereChaineTitre('[ascap]');">
<input type="button" value="Adr Usine" onclick="insereChaineTitre('[adrusine]');">
<input type="button" value="Usine" onclick="insereChaineTitre('[usine]');">
<br>
<textarea name="titre" cols="120" rows="5" ONCHANGE="setPosCurseurTitre()" ONCLICK="setPosCurseurTitre()"><% =unescape(rsEtiquette("ETIQ"))%></textarea>
<br><br>


<br><br>
<input type="submit" value="Enregistrer">
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
</form>
</center>
</body>
</html>
<%
rsEtiquette.close
set rsEtiquette=Nothing 
%>

<!--#include file="../common/kill.asp"-->