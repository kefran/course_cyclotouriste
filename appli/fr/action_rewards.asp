<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


dim strSQL
Dim intNb


strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=" & "'" & request.form("3p") & "'" & " WHERE NBPARTICIPATION=3"
response.write(strSQL)
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("6p") & """ WHERE NBPARTICIPATION=6"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("9p") & """ WHERE NBPARTICIPATION=9"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("12p") & """ WHERE NBPARTICIPATION=12"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("15p") & """ WHERE NBPARTICIPATION=15"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("18p") & """ WHERE NBPARTICIPATION=18"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("21p") & """ WHERE NBPARTICIPATION=21"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("24p") & """ WHERE NBPARTICIPATION=24"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("27p") & """ WHERE NBPARTICIPATION=27"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if

strSQL="UPDATE RECOMPENSE SET LIBRECOMPENSE=""" & request.form("30p") & """ WHERE NBPARTICIPATION=30"
intNb=0
Conn.execute strSQL,intNb,adcmdtext
if intNb<>1 then	
	Session("strError")="Erreur lors de la sauvegarde des récompenses."
	response.redirect "rewards.asp"		
end if


'Tout est ok
Session("strError")="Récompenses mises à jour!"
response.redirect "index_admin.asp"		

%>


<!--#include file="../common/kill.asp"-->