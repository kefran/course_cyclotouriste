<!--#include file="../common/init.asp"-->

<%


'Acc�s uniquement aux admins
call TestAdmin

response.redirect "action_start_stop.asp?action=stop&password=" & request.form("password")
%>





<!--#include file="../common/kill.asp"-->