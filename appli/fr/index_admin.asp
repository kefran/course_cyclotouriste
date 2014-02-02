<!--#include file="../common/init.asp"-->

<%
'Acc�s uniquement aux admins
call TestAdmin

%>


<html>
<!-- Date de cr�ation: 02/06/2004 -->
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="http://code.jquery.com/jquery.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
<script src="../common/xhr.js" ></script>

</head>
<body  bgcolor="#F4F9FE">
<% 
call header
call menu %>

<center>

<h1>ACCUEIL ADMINISTRATEUR DE LA COURSE</h1>

<BR><BR>
<div id="tst" name="tst">
<button type="button" onclick="getCoucou();">Clique ici</button>
</div>
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
Veuillez utiliser le menu pour acc�der aux diff�rentes fonctionnalit�s du site.

</center>


</body>
</html>



<br>
<!--#include file="../common/kill.asp"-->

