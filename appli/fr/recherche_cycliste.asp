<!--#include file="../common/init.asp"-->
<%
' Page pour recherche un cycliste par nom, prénom ou ville.
' @auteur Julien Lab
' Dernière modif 24/11/2004

'Accès uniquement aux admins
call TestAdmin
%>
<html>
<head>
<title>Site de Gestion de la Course de LIONNE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function load()
{
	form.nom.focus();
}
</script>
<% call menu_head %>
</head>
<%
call header
call menu %>
<body>
<br>
<h1>Rechercher un cycliste</h1>
<br><br>
<center>
<form name="form" action="liste_cycliste.asp" method="post">
  <table width="800" border="0" cellspacing="0" cellpadding="10">
  <tr>
      <td width="400">Recherche par nom : le nom contient</td>
    <td><input type="text" name="nom" size="50"></td>
  </tr>
  <tr>
      <td>Recherche par pr&eacute;nom : le pr&eacute;nom contient</td>
    <td><input name="prenom" type="text" size="50"></td>
  </tr>
  <tr>
      <td>Recherche par ville :</td>
    <td><input name="ville" type="text" size="50"></td>
  </tr>
  <tr>
    <td align="center" colspan="2"><br><input type="submit" value="Rechercher" name="submit"></td>
  </tr>
</table>

<br><br><br>
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
</center>
</form>
</body>
</html>
<!--#include file="../common/kill.asp"-->