<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Enregistrement du départ d’un cycliste
'
'******************************************
%>

<!--#include file="../common/init.asp"-->


<%
'Accès uniquement aux admins
call TestAdmin
Dim ajax 

if request("ajax")="1" then
	ajax = request("ajax")
	
end if

Dim strSQL
Dim intNumcyc,intNumcourse,intNumcircuit,intKM,strHDEPART,intNbcourses,strRecompense
strRecompense=""

'On vérifie les paramètres passés

if CInt(request("cbnom"))<1 then
	if ajax = 1 then
		response.write("Erreur de choix de cycliste")
		response.end
	else
		Session("strError")="Erreur de choix de cycliste"
		response.redirect "saisie_retour.asp"
	end if 
end if

intNumcyc=CInt(request("cbnom"))
intNumcourse=NumCourse()


'On récupère le numéro du circuit et l'heure de départ
Dim rsCourses
set rsCourses = Server.CreateObject("ADODB.recordset")
rsCourses.Open "SELECT NUMCIRCUIT,HDEPART FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
if rsCourses.EOF then
	if ajax=1 then
		response.Charset="ISO-8859-1"
		response.write(intNumcourse&" MEEEEEEEEEEEERDE")
		response.write("Impossible de trouver le circuit sélectionné par le coureur 		dans la table PARTICIPER")
		response.end
	else
		Session("strError")="Impossible de trouver le circuit sélectionné par le 	coureur dans la table PARTICIPER"
		response.redirect "saisie_retour.asp"
	end if

end if

intNumcircuit=CInt(rsCourses("NUMCIRCUIT"))
strHDEPART=rsCourses("HDEPART")
rsCourses.close

'On récupère le nombre de courses du cycliste
rsCourses.Open "SELECT NBCOURSES FROM CYCLISTE WHERE NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
if rsCourses.EOF then
	if ajax=1 then
		response.Charset="ISO-8859-1"
		response.write("Impossible de trouver le cycliste sélectionné dans la 	table CYCLISTE")
		response.end

	else
		Session("strError")="Impossible de trouver le cycliste sélectionné dans la 	table CYCLISTE"
		response.redirect "saisie_retour.asp"
	end if
end if
intNbcourses=rsCourses("NBCOURSES")
rsCourses.close
if intNbcourses mod 3 =0 then
	rsCourses.Open "SELECT LIBRECOMPENSE FROM RECOMPENSE WHERE NBPARTICIPATION=" & intNbcourses,Conn,adOpenForwardOnly,adLockReadOnly
	if rsCourses.EOF then
		if ajax=1 then 
			response.Charset="ISO-8859-1"
			response.write((intNbcourses mod 3))
			response.write("Impossible de trouver la récompense correspondante dans la table des récompenses")
			response.end
		else
		Session("strError")="Impossible de trouver la récompense correspondante dans la table des récompenses"
		response.redirect "saisie_retour.asp"
		end if
	end if
	strRecompense=rsCourses("LIBRECOMPENSE")
	rsCourses.close
end if


'On récupère la distance du circuit
rsCourses.Open "SELECT DISTANCEC1,DISTANCEC2,DISTANCEC3 FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
if rsCourses.EOF then
	if ajax=1 then
		response.Charset="ISO-8859-1"
		response.write("Impossible de trouver la distance du circuit sélectionné dans la table COURSE")
		response.end
	else
		Session("strError")="Impossible de trouver la distance du circuit sélectionné dans la table COURSE"
		response.redirect "saisie_retour.asp"
	end if
end if
if intNumcircuit=1 then
	intKM=rsCourses("DISTANCEC1")
elseif intNumcircuit=2 then
	intKM=rsCourses("DISTANCEC2")
elseif intNumcircuit=3 then
	intKM=rsCourses("DISTANCEC3")
else
	if ajax=1 then
		response.Charset="ISO-8859-1"
		response.write("Impossible de trouver la distance du circuit sélectionné dans la table COURSE")
		response.end
	else
		Session("strError")="Impossible de trouver la distance du circuit sélectionné dans la table COURSE"
		response.redirect "saisie_retour.asp"
	end if
end if
rsCourses.close
Set rsCOurses=Nothing



'Les modifications sont effectuées dans le cadre d une transaction
Conn.BeginTrans
Conn.CommandTimeOut=120

'On écrit l heure d'arrivée dans la table PARTICIPER
if Application("blnBDDOracle")=true then		
	strSQL="UPDATE PARTICIPER "
	strSQL=strSQL & "SET HARRIVEE=TO_DATE('" & Time() & "','HH24:MI:SS') "
	strSQL= strSQL & "WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc & " "

else
	strSQL="UPDATE PARTICIPER "
	strSQL=strSQL & "SET HARRIVEE='" & Time() & "' "
	strSQL= strSQL & "WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc & " "
end if

Dim intNb
intNb=0

Conn.execute strSQL,intNb,adcmdtext
	
if intNb<>1 then	
	if ajax=1 then
		response.Charset="ISO-8859-1"
		Conn.RollbackTrans
		response.write("Erreur lors de l'enregistrement de l'arrivéee du cycliste " & request.form("cbnom") & ".")
		response.end
	else
		Session("strError")="Erreur lors de l'enregistrement de l'arrivéee du cycliste " & request.form("cbnom") & "."
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"		
	end if
end if

'On modifie également l heure de retour RETOUR dans la table CYCLISTE
if Application("blnBDDOracle")=true then		
	strSQL="UPDATE CYCLISTE "
	strSQL=strSQL & "SET RETOUR=TO_DATE('" & Time() & "','HH24:MI:SS') "
	strSQL= strSQL & "WHERE NUMCYC=" & intNumcyc

else
	strSQL="UPDATE CYCLISTE "
	strSQL=strSQL & "SET RETOUR='" & Time() & "' "
	strSQL= strSQL & "WHERE NUMCYC=" & intNumcyc
end if

intNb=0
Conn.execute strSQL,intNb,adcmdtext	

if intNb<>1 then
	if ajax=1 then 
		response.Charset="ISO-8859-1"
		Conn.RollbackTrans
		response.write("Erreur lors de l'enregistrement de l'heure de retour du cycliste " & request.form("cbnom") & " dans la table CYCLISTE.")
		response.end
	else
		Session("strError")="Erreur lors de l'enregistrement de l'heure de retour du cycliste " & request.form("cbnom") & " dans la table CYCLISTE."
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"
	end if
end if

'On incrémente le champ KM du CYCLISTE
Dim rsMAJ
set rsMAJ = Server.CreateObject("ADODB.recordset")
strSQL="SELECT KM FROM CYCLISTE WHERE NUMCYC=" & intNumcyc

rsMAJ.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
if rsMAJ.EOF then
	if ajax=1 then 
		response.Charset="ISO-8859-1"
		Conn.RollbackTrans
		reponse.write("Erreur lors de la recherche du cycliste " & request.form("cbnom") & ".")
		response.end
	else
		Session("strError")="Erreur lors de la recherche du cycliste " & request.form("cbnom") & "."
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"	
	end if
end if

if isNull(rsMAJ("KM")) then
	'Rien à faire
else
	intKM=CInt(rsMAJ("KM"))+CInt(intKM)
end if
rsMAJ.close

strSQL="UPDATE CYCLISTE SET KM=" & intKM & " WHERE NUMCYC=" & intNumcyc
Conn.execute strSQL,intNb,adcmdtext
	
if intNb<>1 then
	if ajax=1 then 
		response.Charset="ISO-8859-1"
		Conn.RollbackTrans
		response.write("Erreur lors de la mise à jour du cycliste " & request.form("cbnom") & ".")
		response.end
	else
	
		Session("strError")="Erreur lors de la mise à jour du cycliste " & request.form("cbnom") & "."
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"	
	end if
end if


'On incrémente le nombre de retour dans la table COURSE
if intNumcircuit=1 then
	strSQL="UPDATE COURSE SET NBRETOURC1=NBRETOURC1+1, NBRETOURTOTAL=NBRETOURTOTAL+1 WHERE NUMCOURSE=" & intNumcourse
elseif intNumcircuit=2 then
	strSQL="UPDATE COURSE SET NBRETOURC2=NBRETOURC2+1, NBRETOURTOTAL=NBRETOURTOTAL+1 WHERE NUMCOURSE=" & intNumcourse
elseif intNumcircuit=3 then
	strSQL="UPDATE COURSE SET NBRETOURC3=NBRETOURC3+1, NBRETOURTOTAL=NBRETOURTOTAL+1 WHERE NUMCOURSE=" & intNumcourse
end if

Conn.execute strSQL,intNb,adcmdtext

if intNb<>1 then
	if ajax=1 then 
		response.Charset="ISO-8859-1"
		Conn.RollbackTrans
		response.write("Erreur lors de la mise à jour du nombre de retours dans la table COURSE.")
		response.end
	else
	Session("strError")="Erreur lors de la mise à jour du nombre de retours dans la table COURSE."
	Conn.RollbackTrans
	response.redirect "saisie_retour.asp"
	end if	
end if


'Tout s'est bien passé...
Conn.CommitTrans
Dim strTEMPS
strTEMPS=CDate(CDate(DateConvert(strHDEPART))-Time())
if strRecompense="" then
	if ajax=1 then 
		response.Charset="ISO-8859-1"
		response.write("OK|Retour du cycliste " & request.form("cbnom") & " enregistré!<br/><br/>Il a mis " & DateConvert(strTEMPS) & " pour effectuer le parcours " & intNumcircuit)
		response.end
	else
		Session("strError")="OK|Retour du cycliste " & request.form("cbnom") & " enregistré!<br/><br/>Il a mis " & DateConvert(strTEMPS) & " pour effectuer le parcours " & intNumcircuit
	end if

else
	if ajax=1 then
		response.Charset="ISO-8859-1"
		response.write("OK|Retour du cycliste " & request.form("cbnom") & " enregistré! <br/> <br/>Il a mis " & DateConvert(strTEMPS) & " pour effectuer le parcours " & intNumcircuit & "<br/> Lot gagné: " & strRecompense & " pour sa " & intNbcourses & "ème participation.")
		response.end
	else
		Session("strError")="OK|Retour du cycliste " & request.form("cbnom") & " enregistré! <br/> <br/>Il a mis " & DateConvert(strTEMPS) & " pour effectuer le parcours " & intNumcircuit & "<br/>Lot gagné: " & strRecompense & " pour sa " & intNbcourses & "ème participation."
	end if
end if

rsMAJ.Open "SELECT NBPARTICIPANTSTOTAL,NBRETOURTOTAL FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly

rsMAJ.close
set rsMAJ=Nothing

response.redirect "saisie_retour.asp"


%>

<!--#include file="../common/kill.asp"-->