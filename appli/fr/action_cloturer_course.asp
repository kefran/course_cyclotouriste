<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Cloture la course
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%


'Accès uniquement aux admins
call TestAdmin

Dim intNumcourse,strDecompte
intNumcourse=NumCourse()



Dim rsCourses,rsCyc
set rsCourses = Server.CreateObject("ADODB.recordset")
set rsCyc = Server.CreateObject("ADODB.recordset")

'On vérifie l'heure passée
dim strHeure
strHeure=request.form("heure")



if (Len(strHeure)<>5) then
	Session("strError")="Heure non valide"
	response.redirect "cloturer_course.asp"
end if

if CInt(Mid(strHeure,1,2))<0 or CInt(Mid(strHeure,1,2))>23 then
	Session("strError")="Heure non valide"
	response.redirect "cloturer_course.asp"
end if

if CInt(Mid(strHeure,4,2))<0 or CInt(Mid(strHeure,4,2))>59 then
	Session("strError")="Heure non valide"
	response.redirect "cloturer_course.asp"
end if

if Mid(strHeure,3,1)<>":" then
	Session("strError")="Heure non valide"
	response.redirect "cloturer_course.asp"
end if

Dim strSQL
Dim ArrCyclistes,intNbcyc,i,intNumcyc,intNumcircuit,strHDEPART,intKM
strSQL="SELECT COUNT(NUMCYC) AS NB FROM CYCLISTE WHERE DERNUMCOURSE=" & intNumcourse & " AND DEPART <>0 AND( RETOUR IS NULL OR RETOUR=0)"
rsCourses.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
intNbcyc=rsCourses("NB")
rsCourses.close

strSQL="SELECT NUMCYC FROM CYCLISTE WHERE DERNUMCOURSE=" & intNumcourse & " AND DEPART <>0 AND( RETOUR IS NULL OR RETOUR=0)"
rsCourses.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly

if rsCourses.EOF then
	'Pas de coureurs non rentrés, la course est déjà cloturée
	Session("strError")=Session("strError") & "<br><br><br>TOUS LES COUREURS SONT ARRIVES! PAS BESOIN DE CLOTURER LA COURSE"
	response.redirect "index_admin.asp"
end if

ArrCyclistes=rsCourses.GetRows
rsCourses.close


'Dans le cadre d'une transaction...
Conn.BeginTrans
Conn.CommandTimeOut=120



for i=0 to intNbcyc-1
	intNumcyc=ArrCyclistes(0,i)
	
	'On récupère le numéro du circuit et l heure de départ
	rsCourses.Open "SELECT NUMCIRCUIT,HDEPART FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
	if rsCourses.EOF then
		Session("strError")="Impossible de trouver le circuit sélectionné par le coureur " & intNumcyc & " dans la table PARTICIPER"
		response.redirect "cloturer_course.asp"
	end if
	intNumcircuit=CInt(rsCourses("NUMCIRCUIT"))
	strHDEPART=rsCourses("HDEPART")
	rsCourses.close
	
	
	
	'On récupère la distance du circuit
	rsCourses.Open "SELECT DISTANCEC1,DISTANCEC2,DISTANCEC3 FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
	if rsCourses.EOF then
		Session("strError")="Impossible de trouver la distance du circuit sélectionné dans la table COURSE"
		Conn.RollbackTrans
		response.redirect "cloturer_course.asp"
	end if
	if intNumcircuit=1 then
		intKM=rsCourses("DISTANCEC1")
	elseif intNumcircuit=2 then
		intKM=rsCourses("DISTANCEC2")
	elseif intNumcircuit=3 then
		intKM=rsCourses("DISTANCEC3")
	else
		Session("strError")="Impossible de trouver la distance du circuit sélectionné dans la table COURSE"
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"
	end if
	rsCourses.close
		
		
	'On écrit l heure d arrivée dans la table PARTICIPER
	if Application("blnBDDOracle")=true then		
		strSQL="UPDATE PARTICIPER "
		strSQL=strSQL & "SET HARRIVEE=TO_DATE('" & strHeure & "','HH24:MI') "
		strSQL= strSQL & "WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc & " "
	
	else
		strSQL="UPDATE PARTICIPER "
		strSQL=strSQL & "SET HARRIVEE='" & strHeure & ":00' "
		strSQL= strSQL & "WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc & " "
	end if
	
	Dim intNb
	intNb=0
	
	Conn.execute strSQL,intNb,adcmdtext
		
	if intNb<>1 then	
		Session("strError")="Erreur lors de l'enregistrement de l'arrivéee du cycliste " & intNumcyc & "."
		Conn.RollbackTrans
		response.redirect "cloturer_course.asp"		
	end if
	
	
	'On modifie également l heure de retour RETOUR dans la table CYCLISTE
	if Application("blnBDDOracle")=true then		
		strSQL="UPDATE CYCLISTE "
		strSQL=strSQL & "SET RETOUR=TO_DATE('" & strHeure & "','HH24:MI') "
		strSQL= strSQL & "WHERE NUMCYC=" & intNumcyc
	
	else
		strSQL="UPDATE CYCLISTE "
		strSQL=strSQL & "SET RETOUR='" & strHeure & ":00' "
		strSQL= strSQL & "WHERE NUMCYC=" & intNumcyc
	end if
	
	intNb=0
	Conn.execute strSQL,intNb,adcmdtext	
	
	if intNb<>1 then
		Session("strError")="Erreur lors de l'enregistrement de l'heure de retour du cycliste " & request.form("cbnom") & " dans la table CYCLISTE."
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"
	end if
	
		
	'On incrémente le champ KM du CYCLISTE
	Dim rsMAJ
	set rsMAJ = Server.CreateObject("ADODB.recordset")
	strSQL="SELECT KM FROM CYCLISTE WHERE NUMCYC=" & intNumcyc
	
	rsMAJ.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
	if rsMAJ.EOF then
		Session("strError")="Erreur lors de la recherche du cycliste " & intNumcyc & "."
		Conn.RollbackTrans
		response.redirect "cloturer_course.asp"	
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
		Session("strError")="Erreur lors de la mise à jour du cycliste " & request.form("cbnom") & "."
		Conn.RollbackTrans
		response.redirect "cloturer_course.asp"	
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
		Session("strError")="Erreur lors de la mise à jour du nombre de retours dans la table COURSE."
		Conn.RollbackTrans
		response.redirect "saisie_retour.asp"	
	end if

	
	
	
next

'Tout s est bien passé...
Conn.CommitTrans


Session("strError")=Session("strError") & "<br><br><br>LA COURSE A ETE CLOTUREE AVEC POUR HEURE D'ARRIVEE " & strHeure & " (" & intNbcyc & " coureurs concernés)"
response.redirect "index_admin.asp"

%>

<!--#include file="../common/kill.asp"-->