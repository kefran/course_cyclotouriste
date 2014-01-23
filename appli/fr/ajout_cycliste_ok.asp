<!--#include file="../common/init.asp"-->
<%
' Validation de l'ajout d'un cycliste
' @auteur Julien Lab
' Dernière modif 24/11/2004
%>
<html>
<head>
<title>Site de gestion de la course de la LIONNE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<%
' Vérification de la connexion
If Session("strAdmin") = "true" Then 
	call menu_head
End If
%>

</head>
<body>
<%
' Appel du header commun
call header
' Vérification de la connexion
If Session("strAdmin") = "true" Then
	call menu 
End If
%>

<br>
<center>
<%
' Affichage de l'erreur
if Session("strError")<>"" then
%>
<br>
<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>
<br><br>

<% end if 
Session("strError")="" %>
<br><br>
<% If Session("strAdmin") = "true" Then %>
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
<% Else %>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('../default.asp');">
<% End If %>
</center>
</body>
</html>
<!--#include file="../common/kill.asp"-->