<!--#include file="../common/init.asp"-->
<html>
	<head>
		<% call login_header %>
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
		<center>
		<div class="alert alert-error">
			<% =Session("strError") %> azeaze
		</div>
		</center>
		<br>
		
		<% end if 
		Session("strError")="" %>
		</div>
	</body>
</html>
<!--#include file="../common/kill.asp"-->