<!--#include file="../common/init.asp"-->

<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>

<script src="../bootstrap/js/bootstrap.js"></script>
<script src="../jquery.js"></script>
<link href="../bootstrap/css/bootstrap.min.ie.css" rel="stylesheet" type="text/css" />
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body onload="form1.pass.focus();">
<div class="container">
<% 
call header
%>
<form name="form1" action="action_login_admin.asp" method="post"  class="form-signin form-inline">
    <h3 class="form-signin-heading">Connexion Administration</h3>
    <b>Mot de passe:</b> 
  	<input type="password" name="pass" class="input-small">
    <button class="btn btn-primary" type="submit">Connecter</button>
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
</div>
</body>
</html>

<!--#include file="../common/kill.asp"-->