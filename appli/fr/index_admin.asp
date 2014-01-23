<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin

%>


<html>
<!-- Date de création: 02/06/2004 -->
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#F4F9FE">
<% 
call header
call menu %>

<center>

<h1>ACCUEIL ADMINISTRATEUR DE LA COURSE</h1>

<BR><BR>

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
Veuillez utiliser le menu pour accéder aux différentes fonctionnalités du site.

</center>


</body>
</html>



<br>
<!--#include file="../common/kill.asp"-->

