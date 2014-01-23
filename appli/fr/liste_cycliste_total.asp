<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Affiche tous les cyclistes enregistrés et les impriment
'
'******************************************
%>

<!--#include file="../Common/init.asp" -->
<%
' Affichage de la liste des cyclistes complète
' @auteur Julien Lab
' Dernière modif 24/11/2004


call TestAdmin

Dim strColor, rsCycliste

strColor = "#DDEAEE"

' Récupère tous les cyclistes
Set rsCycliste = Server.CreateObject("ADODB.Recordset")
rsCycliste.open "SELECT * FROM Cycliste Order By Nom", Conn, adOpenKeySet, adLockOptimistic
%>
<html>
<head>
<title>Site de Gestion de la course de la LIONNE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<% call menu_head %>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
call header
call menu %>
<br>
<center>
<H1>
Liste des cyclistes enregistrés

</H1>
<br><br>
<table width="90%" border="0">
  <tr bgcolor="#CCFFFF"> 
    <td width="5%" align="center" bgcolor="#CCD1E0"><strong>Numéro</strong></td>
    <td width="15%" align="center" bgcolor="#CCD1E0"><strong>Nom</strong></td>
    <td width="15%" align="center" bgcolor="#CCD1E0"><strong>Prénom</strong></td>
    <td width="6%" align="center" bgcolor="#CCD1E0"><strong>Sexe</strong></td>
    <td width="27%" align="center" bgcolor="#CCD1E0"><strong>Adresse</strong></td>
    <td width="18%" align="center" bgcolor="#CCD1E0"><strong>Ville</strong></td>
  </tr>
  <tr> 
    <td height="5" colspan="7"></td>
  </tr>
  <% 'Boucle d'affichage
If NOT rsCycliste.EOF Then
	Do While NOT rsCycliste.EOF
		If strColor = "#FBFBFB" Then strColor = "#DDEAEE" Else strColor = "#FBFBFB"
%>
  <tr> 
    <td bgcolor="<%=strColor%>" align="center"><%=rsCycliste("Numcyc")%>&nbsp;</td>
    <td bgcolor="<%=strColor%>" align="center"><%=rsCycliste("Nom")%>&nbsp;</td>
    <td bgcolor="<%=strColor%>" align="center"><%=rsCycliste("Prenom")%>&nbsp;</td>
    <td bgcolor="<%=strColor%>" align="center"><%=rsCycliste("Sexe")%>&nbsp;</td>
    <td bgcolor="<%=strColor%>" align="center"><%=rsCycliste("Adresse")%>&nbsp;</td>
    <td bgcolor="<%=strColor%>" align="center"><%=rsCycliste("Ville")%>&nbsp;</td>
  </tr>
  <%
		rsCycliste.MoveNext
	Loop
rsCycliste.close
Set rsCycliste = nothing
Else
%>
  <tr> 
    <td>&nbsp;</td>
    <td colspan="5" align="center" class="textes"> Aucun cycliste enregistré </td>
  </tr>
  <%
End If
%>
</table>
<br><br>
<input type="button" value="Imprimer" onclick="window.print();">
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
</center>
</body>
</html>
<!--#include file="../Common/kill.asp" -->