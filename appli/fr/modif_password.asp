<!--#include file="../Common/init.asp" -->
<%
' Page de modification d'un mot de passe. Permet de saisir le nouveau mot de passe.
' @auteur Julien Lab
' Dernière modif 24/11/2004
%>
<html>
<head>
<title>Site de Gestion de la Course de la LIONNE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<%
If Session("intUser") < 0 Then
	call menu_head
End If
%>
</head>

<body>
<%
call header
If Session("intUser") < 0 Then 
	call menu
End If
%>
<center>
<br><br>
<h1>Modification du mot de passe</h1>
<br><br>
<form action="action_modif_password.asp" method="post" name="password">
<input type="hidden" name="num" value="<%=Request("numcyc")%>">
<center>
<table width="500" border="0" cellpadding="0">
  <tr>
    <td>Mot de passe&nbsp;</td>
    <td><input type="password" name="mdp">&nbsp;</td>
  </tr>
  <tr>
    <td>Entrez à nouveau le mot de passe&nbsp;</td>
    <td><input type="password" name="remdp">&nbsp;</td>
  </tr>
  <tr>
  	<td align="center" colspan="2"><input type="submit" name="Submit" value="Ok"></td>
  </tr>
</table>

</form>
<center>
<% If Session("strAdmin") = "true" Then %>
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
<% Else %>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('../default.asp');">
<% End If %>
</center>

</body>
</html>
<!--#include file="../Common/kill.asp" -->