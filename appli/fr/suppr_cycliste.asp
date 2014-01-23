<!--#include file="../Common/init.asp" -->
<%
' Suppression d'un cycliste.
' @auteur Julien Lab
' Dernière modif 24/11/2004

'Accès uniquement aux admins
call TestAdmin
%>
<html>
<head>
<title>Site de Gestion de la course de la LIONNE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<% call menu_head %>
</head>

<body>
<%
call header
call menu
%>
<br>
<center>
<form name="form1" action="action_suppr_cycliste.asp" method="POST">
<input type="hidden" name="numsupp" value="<%=Request("numcyc")%>">
<b>Mot de passe</b>:&nbsp;<input type="password" name="password" size="10" maxlength="25">
<br><br>
<input type="submit" value="Supprimer le cycliste n° <%=Request("numcyc")%>" height="100" width="150">
</form>
<br>
<% If Session("intUser") > 0 Then %>
<input type="button" value="Retour à l'accueil de l'utilisateur" onclick="window.location.replace('index_user.asp');">
<% ElseIf Session("strAdmin") = "true" Then %>
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
<% Else %>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('../default.asp');">
<% End If %>
</center>

</body>
</html>

<!--#include file="../Common/kill.asp" -->