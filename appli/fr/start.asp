<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Démarrage d'une course
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
	Session("strError")=Session("strError") & "<br>La course a déjà été demarrée!"
	response.redirect "index_admin.asp"
else
	blnDecompte=false
end if

rsCourses.close



%>

<html>
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>

<script type="text/javascript">


function rediriger_start() { 
	var url='action_start_stop.asp?action=start&password=' + document.forms[0].password.value; 
	window.location.replace(url);	
} 

</script>
<link href="../style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function load()
{
	form1.password.focus();
}
</script>

</head>
<body>
<% 
call header
call menu %>

<center>
<H1>DEMARRER LA COURSE</H1>

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
Course cycliste "La Lionne" du <% =strDatecourse %> - Edition <% = strAnneecourse %>
<br><br><br>
<form name="form1" action="action_rediriger_start.asp" method="POST">
<b>Mot de passe</b>:&nbsp;<input type="password" name="password" size="10" maxlength="25">
<br><br>
<table border="5" bordercolor="#0000CC">
	<tr>
		<td><input type="submit" value="Démarrer la course" height="100" width="150" onclick="rediriger_start();" 
		<% if blnDecompte=true then
			response.write(" disabled")
		end if %>
		></td>
	
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