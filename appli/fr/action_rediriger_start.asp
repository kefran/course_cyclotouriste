<!--#include file="../common/init.asp"-->

<%


'Accès uniquement aux admins
call TestAdmin

response.redirect "action_start_stop.asp?action=start&password=" & request.form("password")
%>





<!--#include file="../common/kill.asp"-->