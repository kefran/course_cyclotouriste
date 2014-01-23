<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


'On récupère les infos sur la course courante
Dim rsCourse
Set rsCourse = Server.CreateObject("ADODB.recordset")
rsCourse.Open "SELECT * FROM COURSE WHERE NUMCOURSE=" & NumCourse(),Conn,adOpenForwardOnly,adLockReadOnly
if rsCourse.EOF then
	Session("strError")="Impossible d'obtenir les informations de la course courante"
	response.redirect "../fr/index_admin.asp"
end if

Dim strDatecourse,strAnneecourse
strDatecourse=rsCourse("DATECOURSE")
strAnneecourse=rsCourse("ANNEECOURSE")

rsCourse.close
Set rsCourse=Nothing


%>

<html>
<head>
<SCRIPT LANGUAGE="JavaScript">

var Compteur = null; 
var CompteurTourne = false;

function DemarreHorloge () { 
  if(CompteurTourne) 
  clearTimeout(Compteur); 
  CompteurTourne = false; 
  AfficheTemps(); 
  } 

function AfficheTemps () { 
  var Temps = new Date(); 
  var TempsLocal = Temps.getTime()+ (Temps.getTimezoneOffset()-60)*60; 
  var Maintenant = new Date(TempsLocal); 
  var Heure = " " + Maintenant.getHours(); 
  var minutes = Maintenant.getMinutes(); 
  var secondes = Maintenant.getSeconds(); 
  Heure += ((minutes < 10) ? ":0" : ":") + minutes; 
  Heure += ((secondes < 10) ? ":0" : ":") + secondes; 
  document.Horloge.FenetreHeure.value = Heure; 
  var AujourdHui = " " + Maintenant.getDate(); 
  var Mois = Maintenant.getMonth()+1; 
  var Annee = Maintenant.getYear(); 
  AujourdHui += "/" + Mois + "/" + Annee; 
  Compteur = setTimeout("AfficheTemps()",1000); 
  CompteurTourne = true; 
  }
// -->
</SCRIPT>
</head>
<body onload="DemarreHorloge()">


<center>


<FORM name="Horloge" onSubmit="0">
Course de la Lionne édition <b><% =strAnneecourse %></b> du <% =DateConvert(strDatecourse) %>
&nbsp;&nbsp;
<INPUT type="text" name="FenetreHeure" size="8" maxlength="8" style="font: bold" align="middle">
</FORM>


</center>
</body>
</html>

<!--#include file="../common/kill.asp"-->