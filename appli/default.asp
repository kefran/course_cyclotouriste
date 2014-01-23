<!--#include file="common/init.asp"-->

<%
'On initialise/réinitialise les variables
'Session("strError")=""
Session("strAdmin")="false"
Session("intUser")=-1

if Application("blnBDDOracle")=false then
	response.redirect "fr/login_admin.asp"
end if
%>

<html>
<!-- Date de création: 02/06/2004 -->
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="style.css" rel="stylesheet" type="text/css">

</head>
<body>
<%
call header_index
%>

<center>
<br><br>
Bonjour! Veuillez vous identifier à l'aide de votre login et de votre mot de passe:<br><br>
Si vous êtes une nouveau coureur, veuillez vous inscrire:<a href="fr/inscription.asp" title="S'inscrire...">S'inscrire...</a>
<br>


<form name="form1" action="fr/action_login.asp" method="post">
<table summary="" border="0">
	<tr>
		<td></td>
		<td align=right>Login:</td>
		<td><input type="text" name="login" size="15" maxlength="15"></td>
		<td></td>
	</tr>
	<tr>
		<td></td>
		<td align=right>Mot de passe:</td>
		<td><input type="password" name="pass" size="15" maxlength="15"></td>
		<td></td>
	</tr>
</table>
<br>
<input type="submit" value="Valider">
</form>

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


<a href="fr/login_admin.asp" title="Accès administrateur...">Accès administrateur de la course</a>


<%



%>
</center>
</body>
</html>

<!--#include file="common/kill.asp"-->