<!--#include file="../common/init.asp"-->

<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
<link rel="Alternate StyleSheet" type="text/css" href="../bootstrap/css/bootstrap.css"  />
</head>
<body onload="form1.pass.focus();">
<% 
call header
%>
<center>

<H1>SITE DE GESTION DE LA COURSE DE LA LIONNE</h1>
<br><br><br>
<H2> ACCES ADMINISTRATEUR DE LA COURSE</H2>

<form name="form1" action="action_login_admin.asp" method="post">
Pour accéder aux pages de gestion de la course, veuillez entrer le mot de passe:
<table summary="" border="0">
	<tr>
		<td></td>
		<td align=right></td>
		<td></td>
		<td></td>
	</tr>
	<tr>
		<td></td>
		<td align=right></td>
		<td><input type="password" name="pass" size="15" maxlength="15"></td>
		<td></td>
	</tr>
</table>
<br>
<input type="submit" value="Valider">
<input type="button" value="Annuler" onclick="window.location.replace('../default.asp');">
</form>

<%
' Affichage de l'erreur le cas échéant

if Session("strError")<>"" then
%>
<br>
<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>
<br>

<% end if 
Session("strError")="" %>
</center>
</body>
</html>

<!--#include file="../common/kill.asp"-->