<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Enregistrement du format des �tiquettes
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Acc�s uniquement aux admins
call TestAdmin


Dim intNumEtiq
If request.querystring("NUM")="1" then
	intNumEtiq=1
elseif request.querystring("NUM")="2" then
	intNumEtiq=2	
elseif request.querystring("NUM")="3" then
	intNumEtiq=3
elseif request.querystring("NUM")="4" then
	intNumEtiq=4
else
	Session("strError")="Param�tre des �tiquettes � modifier incorrect!"
	response.redirect "index_admin.asp"
end if


Dim strSQL, intNb
strSQL="UPDATE ETIQUETTE SET ETIQUETTE" & intNumEtiq & "='" & request.form("titre") & "' WHERE ID=1"
Conn.execute strSQL,intNb,adcmdtext	
if intNb<>1 then
	Session("strError")="Erreur lors de la mise � jour des etiquettes"
	Response.redirect "edit_etiquettes.asp?num=" & intNumEtiq
end if

Session("strError")="Etiquettes mises � jour!"
Response.redirect "index_admin.asp"

%>

<!--#include file="../common/kill.asp"-->