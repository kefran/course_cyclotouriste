<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Page de clôture d’une course
'
'******************************************
%>


<!--#include file="../common/init.asp"-->

<%


'Accès uniquement aux admins
call TestAdmin



Dim intNumcourse,strDatecourse,strAnneecourse,blnDecompte

Dim rsCourses
set rsCourses = Server.CreateObject("ADODB.recordset")

intNumcourse=NumCourse()
rsCourses.Open "SELECT DECOMPTE,DATECOURSE,ANNEECOURSE FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
strDatecourse=rsCourses("DATECOURSE")
strAnneecourse=rsCourses("ANNEECOURSE")
if rsCourses("DECOMPTE")="Vrai" then
	blnDecompte=true
else
	blnDecompte=false
	Session("strError")=Session("strError") & "<br>La course a déjà été arrêtée!"
	response.redirect "index_admin.asp"
end if

rsCourses.close






%>

<html>
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>

<SCRIPT type=text/javascript>
function valider(){

if (confirm('Cette opération va affecteur l\'heure de retour choisie à tous les cyclistes non arrivés ou non passés à l\'enregistrement. Continuer?')){
	return true
	}
	else
	{
	return false
	}

}

</script>

<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>

<center>
<H1>CLOTURER LA COURSE</H1>

<br>

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

<br><br><br>
Cloturer la course signifie l'affectation d'une heure de retour (définie) à tous les cyclistes non passés à l'enregistrement du retour ou ayant abandonnés de la course Edition <% = strAnneecourse %>


<br><br><br>
<form name="form1" action="action_cloturer_course.asp" method="POST" onSubmit="javascript:return valider()">
<b>Heure de retour à affecter</b>&nbsp;&nbsp;<input type="text" name="heure" size="5" maxlength="5" value="17:00"> &nbsp;(format hh:mm)
<br> 
<br>
<input type="button" value="Imprimer tous les diplômes des cyclistes non rentrés (PDF)" onclick="window.open('action_diplomesPDF.php?mode=non_rentres');">
<br><br>
<input type="button" value="Imprimer tous les diplômes des cyclistes non rentrés (HTML)" onclick="window.open('action_diplomes_non_rentres.asp');">

<br><br>
<table border="5" bordercolor="#0000CC">
	<tr>
		
	<td><input type="submit" value="Cloturer la course" width="150" height="100">
		</td>
	</tr>
</table>
</form>
<br><br><br>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">


</center>

</body>
</html>
<% Set rsCourses=Nothing %>
<!--#include file="../common/kill.asp"-->