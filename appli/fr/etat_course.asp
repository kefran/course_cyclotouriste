<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Conteneur appelant la fenêtre de suivi de la course (permet le rafraîchissement du contenu)
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


Dim rsCourse,blnRefresh
set rsCourse = Server.CreateObject("ADODB.recordset")

rsCourse.Open "Select DECOMPTE from COURSE WHERE NUMCOURSE=" & NumCourse(),Conn,adOpenForwardOnly,adLockReadOnly
if isNull(rsCourse("DECOMPTE")) then
	Session("strError")="INFORMATION: La course n'a pas démarré!"
	blnRefresh=false
elseif rsCourse("DECOMPTE")="Faux" then
	Session("strError")="INFORMATION: La course est terminée."
	blnRefresh=false
else
	Session("strError")="INFORMATION: La course est en cours!<br>"
	blnRefresh=true
end if

rsCourse.close
set rsCourse=Nothing
%>


<html>
<head>
<% call menu_head %>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>
<center>

<IFRAME name=suivi align=center src="etat_course2.asp?refresh=<% =blnRefresh %>" WIDTH=768 HEIGHT=1024 SCROLLING=NO FRAMEBORDER=0></IFRAME>


</center>
</body>
</html>
<!--#include file="../common/kill.asp"-->