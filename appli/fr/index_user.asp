<!--#include file="../common/init.asp"-->
<%
'Acc�s uniquement aux users
call TestUser
%>


<html>
<!-- Date de cr�ation: 02/06/2004 -->
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call menu %>
Page de gestion de l'utilisateur


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
</body>
</html>





<!--#include file="../common/kill.asp"-->

