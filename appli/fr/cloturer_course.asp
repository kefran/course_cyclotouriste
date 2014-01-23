<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Page de cl�ture d�une course
'
'******************************************
%>


<!--#include file="../common/init.asp"-->

<%


'Acc�s uniquement aux admins
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
	Session("strError")=Session("strError") & "<br>La course a d�j� �t� arr�t�e!"
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

if (confirm('Cette op�ration va affecteur l\'heure de retour choisie � tous les cyclistes non arriv�s ou non pass�s � l\'enregistrement. Continuer?')){
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
' Affichage de l'erreur le cas �ch�ant

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
Cloturer la course signifie l'affectation d'une heure de retour (d�finie) � tous les cyclistes non pass�s � l'enregistrement du retour ou ayant abandonn�s de la course Edition <% = strAnneecourse %>


<br><br><br>
<form name="form1" action="action_cloturer_course.asp" method="POST" onSubmit="javascript:return valider()">
<b>Heure de retour � affecter</b>&nbsp;&nbsp;<input type="text" name="heure" size="5" maxlength="5" value="17:00"> &nbsp;(format hh:mm)
<br> 
<br>
<input type="button" value="Imprimer tous les dipl�mes des cyclistes non rentr�s (PDF)" onclick="window.open('action_diplomesPDF.php?mode=non_rentres');">
<br><br>
<input type="button" value="Imprimer tous les dipl�mes des cyclistes non rentr�s (HTML)" onclick="window.open('action_diplomes_non_rentres.asp');">

<br><br>
<table border="5" bordercolor="#0000CC">
	<tr>
		
	<td><input type="submit" value="Cloturer la course" width="150" height="100">
		</td>
	</tr>
</table>
</form>
<br><br><br>
<input type="button" value="Retour � l'accueil" onclick="window.location.replace('index_admin.asp');">


</center>

</body>
</html>
<% Set rsCourses=Nothing %>
<!--#include file="../common/kill.asp"-->