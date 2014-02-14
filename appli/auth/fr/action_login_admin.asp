<!--#include file="../common/init.asp"-->



<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<center>

<%
Dim strURL
if request.form("pass")=Application("stradmin_pass")then
	strURL="index_admin.asp"
	Session("strAdmin")="true"
	Response.Write strURL
	Response.Write("<form method=""post"" id=""postform"" action=""../fr/bridge_loginadmin_php.php"" ><input type=""hidden"" value=""" + strURL+ """ name=""strURL""><input type=""hidden"" value=""" + request.form("pass") + """ name=""pass""><input type=""submit""></form>")
	Response.Write("<script type=""text/javascript"">document.getElementById('postform').submit();</script>")
else
	Session("strError")="Mauvais mot de passe administrateur"
	strURL="login_admin.asp"
	''Dim goToPhpAuth As Boolean = true
end if 

''response.redirect strURL
%>

	
</center>
</body>
</html>

<!--#include file="../common/kill.asp"-->