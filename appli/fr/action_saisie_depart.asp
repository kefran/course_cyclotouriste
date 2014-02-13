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
Dim intNumcyc,intNumcourse,intNumcircuit


if CInt(request("cbnom"))<1 then
	if ajax = 1 then
		response.write("Erreur de choix de cycliste")
		response.end
	else
		Session("strError")="Erreur de choix de cycliste"
		response.redirect "saisie_depart.asp"
	end if 
end if


'On vérifie les paramètres passés
if isNumeric(request("numcircuit"))  then
	if CInt(request("numcircuit"))<1 or CInt(request("numcircuit"))>3 then
		Session("strError")="Vous devez choisir un circuit!"
		
		if ajax = 1 then	
			response.write("Vous devez choisir une course")
			response.end
		else
			response.redirect "saisie_depart.asp?numcyc=" & request("cbnom")
			
		end if 
	end if
else
	if ajax = 1 then	
			response.write("Vous devez choisir une course")
			response.end
		else
			response.redirect "saisie_depart.asp?numcyc=" & request("cbnom")
		end if
end if

intNumcyc=CInt(request("cbnom"))
intNumcourse=NumCourse()
intNumcircuit=CInt(request("numcircuit"))


'Les modifications sont effectuées dans le cadre d une transaction
Conn.BeginTrans
Conn.CommandTimeOut=120

Dim intNb

'On écrit l heure de départ dans la table PARTICIPER

'On doit vérifier que la personne prend bien le départ de la course à laquelle il s'est préinscrit:
Dim rsTest
set rsTest = Server.CreateObject("ADODB.recordset")
rsTest.Open "SELECT NUMCIRCUIT FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
if (not rsTest.EOF) then
	intNb=0
	if CInt(rsTest("NUMCIRCUIT"))<>CInt(request("numcircuit")) then
		strSQL="UPDATE COURSE SET NBPARTICIPANTSC" & rsTest("NUMCIRCUIT") & "=NBPARTICIPANTSC" & rsTest("NUMCIRCUIT") & "-1 WHERE NUMCOURSE=" & intNumcourse
		Conn.execute strSQL,intNb,adcmdtext
		strSQL="UPDATE COURSE SET NBPARTICIPANTSC" & request("numcircuit") & "=NBPARTICIPANTSC" & request("numcircuit") & "+1 WHERE NUMCOURSE=" & intNumcourse
		Conn.execute strSQL,intNb,adcmdtext
	end if
end if	


if Application("blnBDDOracle")=true then		
	strSQL="UPDATE PARTICIPER "
	strSQL=strSQL & "SET NUMCIRCUIT=" & intNumcircuit & ", HDEPART=TO_DATE('" & Time() & "','HH24:MI:SS') "
	strSQL= strSQL & "WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc & " "

else
	strSQL="UPDATE PARTICIPER "
	strSQL=strSQL & "SET NUMCIRCUIT=" & intNumcircuit & ", HDEPART='" & Time() & "' "
	strSQL= strSQL & "WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc & " "
end if


intNb=0

Conn.execute strSQL,intNb,adcmdtext
Dim blnDejaInscrit	
blnDejaInscrit=true
if intNb<>1 then
	'Dans ce cas, on a affaire à une insertion dans la base (le coureur n a pas été préinscrit)
	blnDejaInscrit=false
	if Application("blnBDDOracle")=true then		
		strSQL="INSERT INTO PARTICIPER (NUMCOURSE,NUMCYC,NUMCIRCUIT,HDEPART) "
		strSQL=strSQL & "VALUES (" & intNumcourse & "," & intNumcyc & "," & intNumcircuit & ",TO_DATE('" & Time() & "','HH24:MI:SS')) "
	else
		strSQL="INSERT INTO PARTICIPER (NUMCOURSE,NUMCYC,NUMCIRCUIT,HDEPART) "
		strSQL=strSQL & "VALUES (" & intNumcourse & "," & intNumcyc & "," & intNumcircuit & ",'" & Time() & "')"
	end if
	
	intNb=0
	Conn.execute strSQL,intNb,adcmdtext
		
	if intNb<>1 then		
		if ajax = 1 then 
			Conn.RollbackTrans
			response.write("Erreur lors de l'enregistrement du départ du cycliste " & request("cbnom") & ".")
			response.end
		else
			Session("strError")="Erreur lors de l'enregistrement du départ du cycliste " & request("cbnom") & "."
			Conn.RollbackTrans
			response.redirect "saisie_depart.asp"
		end if
		
	end if
end if

'On modifie également l heure de départ DEPART dans la table CYCLISTE
if Application("blnBDDOracle")=true then		
	strSQL="UPDATE CYCLISTE "
	strSQL=strSQL & "SET DEPART=TO_DATE('" & Time() & "','HH24:MI:SS') "
	strSQL= strSQL & "WHERE NUMCYC=" & intNumcyc

else
	strSQL="UPDATE CYCLISTE "
	strSQL=strSQL & "SET DEPART='" & Time() & "' "
	strSQL= strSQL & "WHERE NUMCYC=" & intNumcyc
end if

intNb=0
Conn.execute strSQL,intNb,adcmdtext	

if intNb<>1 then
	if ajax =1 then 
		Conn.RollbackTrans
		response.write("Erreur lors de l'enregistrement de l'heure de départ du cycliste " & request("cbnom") & " dans la table CYCLISTE.")
		response.end
	else
		Session("strError")="Erreur lors de l'enregistrement de l'heure de départ du cycliste " & request("cbnom") & " dans la table CYCLISTE."
		Conn.RollbackTrans
		response.redirect "saisie_depart.asp"
	end if
end if



'On incrémente le champ NBCOURSES, on modifie les champs DERNUMCOURSE,DERANCOURSE et PARTIC du CYCLISTE
Dim rsMAJ
set rsMAJ = Server.CreateObject("ADODB.recordset")
strSQL="SELECT NBCOURSES FROM CYCLISTE WHERE NUMCYC=" & intNumcyc

rsMAJ.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
if rsMAJ.EOF then
	if ajax =1 then
		Conn.RollbackTrans
		response.write("Erreur lors de la recherche du cycliste " & request("cbnom") & ".")
		response.end
	else
		Session("strError")="Erreur lors de la recherche du cycliste " & request("cbnom") & "."
		Conn.RollbackTrans
		response.redirect "saisie_depart.asp"
	end if
end if



Dim intN
intN=CInt(rsMAJ("NBCOURSES"))+1
rsMAJ.close

'On récupère l année de la course
Dim intAnneeCourse
rsMAJ.Open "SELECT ANNEECOURSE FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
intAnneeCourse=CInt(rsMAJ("ANNEECOURSE"))


strSQL="UPDATE CYCLISTE SET NBCOURSES=" & intN & ", DERNUMCOURSE=" & intNumcourse & ", DERANCOURSE=" & intAnneeCourse & " WHERE NUMCYC=" & intNumcyc
Conn.execute strSQL,intNb,adcmdtext
	
if intNb<>1 then

	if ajax = 1 then
		Conn.RollbackTrans
		response.write("Erreur lors de la mise à jour du cycliste " & request("cbnom") & ".")
		response.end
	else
		Session("strError")="Erreur lors de la mise à jour du cycliste " & request("cbnom") & "."
		Conn.RollbackTrans
		response.redirect "saisie_depart.asp"	
	end if 
end if

'Si la personne ne s'est pas préinscrite -> on ajoute la personne dans la table COURSE
if blnDejaInscrit=false then
	'On met à jour les champs NBPARTCIPANTSCX et NBPARTICIPANTSTOTAL de la table COURSE
	if intNumcircuit=1 then
		strSQL="UPDATE COURSE SET NBPARTICIPANTSC1=NBPARTICIPANTSC1+1, NBPARTICIPANTSTOTAL=NBPARTICIPANTSTOTAL+1 WHERE NUMCOURSE=" & intNumcourse
	elseif intNumcircuit=2 then
		strSQL="UPDATE COURSE SET NBPARTICIPANTSC2=NBPARTICIPANTSC2+1, NBPARTICIPANTSTOTAL=NBPARTICIPANTSTOTAL+1 WHERE NUMCOURSE=" & intNumcourse
	elseif intNumcircuit=3 then
		strSQL="UPDATE COURSE SET NBPARTICIPANTSC3=NBPARTICIPANTSC3+1, NBPARTICIPANTSTOTAL=NBPARTICIPANTSTOTAL+1 WHERE NUMCOURSE=" & intNumcourse
	else
		if ajax = 1 then
			Conn.RollbackTrans
			response.write("Erreur: Aucun circuit sélectionné")
			response.end
		else
			Session("strError")="Erreur: Aucun circuit sélectionné"
			Conn.RollbackTrans
			response.redirect "saisie_depart.asp"
		end if
	end if
	intNb=0
	Conn.execute strSQL,intNb,adcmdtext
	
	if intNb<>1 then
		if ajax = 1 then
			Conn.RollbackTrans
			response.write()
			response.end
		else
		
			Session("strError")="Erreur lors de la mise à jour du nombre de participants dans la table COURSE"
			Conn.RollbackTrans
			response.redirect "saisie_depart.asp"	
		end if
	end if
end if


'On met à jour NBXPARTICIPATIONS de la table COURSE  et on met à jour la table OBTENIR
strSQL=""
Select case intN
	case 3
		strSQL="UPDATE COURSE SET NB3PARTICIPATIONS=NB3PARTICIPATIONS+1 WHERE NUMCOURSE=" & intNumcourse
	case 6
		strSQL="UPDATE COURSE SET NB6PARTICIPATIONS=NB6PARTICIPATIONS+1 WHERE NUMCOURSE=" & intNumcourse
	case 9
		strSQL="UPDATE COURSE SET NB9PARTICIPATIONS=NB9PARTICIPATIONS+1 WHERE NUMCOURSE=" & intNumcourse
	case 12
		strSQL="UPDATE COURSE SET NB12PARTICIPATIONS=NB12PARTICIPATIONS+1 WHERE NUMCOURSE=" & intNumcourse
	case 15
		strSQL="UPDATE COURSE SET NB15PARTICIPATIONS=NB15PARTICIPATIONS+1 WHERE NUMCOURSE=" & intNumcourse
end select

if strSQL<>"" then
	'Alors il faut mettre à jour
	intNb=0
	Conn.execute strSQL,intNb,adcmdtext
	if intNb<>1 then
		if ajax = 1 then
			Conn.RollbackTrans
			response.write("Erreur lors de la mise à jour du nombre de récompense pour participations (champs NBxPARTICIPATIONS) dans la table COURSE")
			response.end
		else
			Session("strError")="Erreur lors de la mise à jour du nombre de récompense pour participations (champs NBxPARTICIPATIONS) dans la table COURSE"
			Conn.RollbackTrans
			response.redirect "saisie_depart.asp"	
		end if
	end if
	
	'On met aussi à jour la table OBTENIR
	strSQL="INSERT INTO OBTENIR (NBPARTICIPATION,NUMCYC) VALUES (" & intN & "," & intNumcyc & ")"
	intNb=0
	Conn.execute strSQL,intNb,adcmdtext
	if intNb<>1 then
		if ajax = 1 then
			Conn.RollbackTrans
			response.write("Erreur lors de la mise à jour de la table OBTENIR")
			response.end
		else
			Session("strError")="Erreur lors de la mise à jour de la table OBTENIR"
			Conn.RollbackTrans
			response.redirect "saisie_depart.asp"	
		end if
	end if 
end if



'Tout s'est bien passé...
Conn.CommitTrans
if ajax=1 then
	response.write("OK|Depart du cycliste " & request("cbnom") & " enregistre!")
else
	Session("strError")="Départ du cycliste " & request("cbnom") & " enregistre!"
	response.redirect "saisie_depart.asp"
end if


%>

<!--#include file="../common/kill.asp"-->