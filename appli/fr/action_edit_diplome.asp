<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Enregistrement du format des diplômes
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin

Dim strSQL, intNb
strSQL="UPDATE DIPLOME SET TITRE='" & request.form("titre") & "', CORPS='" & request.form("corps") & "' WHERE ID=1"
response.write(strSQL)
Conn.execute strSQL,intNb,adcmdtext	
if intNb<>1 then
	Session("strError")="Erreur lors de la mise à jour du diplôme"
	Response.redirect "edit_diplome.asp"
end if

Session("strError")="Diplôme mis à jour!"
Response.redirect "index_admin.asp"

%>

<!--#include file="../common/kill.asp"-->