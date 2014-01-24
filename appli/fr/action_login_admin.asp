<!--#include file="../common/init.asp"-->



<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="http://code.jquery.com/jquery.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<center>

<%
Dim strURL
if request.form("pass")=Application("stradmin_pass")then
	strURL="index_admin.asp"
	Session("strAdmin")="true"
else
	Session("strError")="Mauvais mot de passe administrateur"
	strURL="login_admin.asp"
end if 

response.redirect strURL
%>

	
</center>
</body>
</html>

<!--#include file="../common/kill.asp"-->