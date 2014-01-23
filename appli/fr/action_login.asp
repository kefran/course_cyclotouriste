<!--#include file="../common/init.asp"-->
<!--#include file="../common/md5.asp"-->



<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<center>


<%
Dim rs,strSQL,strURL
Set rs = Server.CreateObject("ADODB.Recordset")
If Application("blnBDDOracle") Then
	strSQL = "SELECT Count(*) AS NB FROM CYCLISTE WHERE LOGIN='" & Ucase(request.form("login")) & "' AND PASSWORD='" & MD5(Ucase(request.form("pass"))) & "'"
Else
	strSQL = "SELECT Count(*) AS NB FROM CYCLISTE WHERE nom='" & Ucase(request.form("login")) & "' AND prenom ='" & Ucase(request.form("pass")) & "'"
End If
rs.Open strSQL, Conn

response.write(rs("NB"))
if rs("NB")<>"1" then
	strURL="../default.asp"
	Session("strError")="Mauvais couple login/mot de passe"
else
	'On récupère le numéro du coureur
	If Application("blnBDDOracle") Then
		strSQL = "SELECT NUMCYC FROM CYCLISTE WHERE LOGIN='" & Ucase(request.form("login")) & "' AND PASSWORD='" & MD5(Ucase(request.form("pass"))) & "'"
	Else
		strSQL = "SELECT NUMCYC FROM CYCLISTE WHERE nom='" & Ucase(request.form("login")) & "' AND prenom ='" & Ucase(request.form("pass")) & "'"	
	End If
	rs.Close
	rs.Open strSQL, Conn
	Dim intnum 
	intnum = CInt(rs("NUMCYC"))
	strURL="edit_cycliste.asp?mode=edit&numedit=" & intnum
	Session("intUser")=intnum
end if

rs.Close
Set rs=Nothing
response.redirect strURL

%>

	
</center>
</body>
</html>

<!--#include file="../common/kill.asp"-->