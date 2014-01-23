<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Fichier ex�cutant les modifications sur le d�part et l�arriv�e d�une course
'
'******************************************
%>

<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Fichier ex�cutant les modifications sur le d�part et l�arriv�e d�une course
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%


'Acc�s uniquement aux admins
call TestAdmin

Dim intNumcourse,strDecompte
intNumcourse=NumCourse()

if Request.QueryString("password")<>Application("stradmin_pass") then
	Session("strError")="Mauvais mot de passe!"
	response.redirect "index_admin.asp"		
end if	


Dim rsCourses
set rsCourses = Server.CreateObject("ADODB.recordset")

'On r�cup�re la valeur du champ DECOMPTE de la course courante pour v�rifier sa valeur
rsCourses.Open "SELECT DECOMPTE FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
strDecompte=rsCourses("DECOMPTE")
rsCourses.close
Set rsCourses=Nothing 

Conn.BeginTrans
Conn.CommandTimeOut=120


Dim intNb

if Request.QueryString("action")="start" then
	'On doit d�marrer la course
	
	'Si DECOMPTE a d�j� "Faux" alors la course a d�j� �t� d�marr�e!
	if strDecompte="Faux" then
		Session("strError")="La course a d�j� eu lieu!"
		Conn.RollbackTrans
		response.redirect "index_admin.asp"		
	end if
	
	
	'Il faut mettre � 0 tous les champs DEPART et RETOUR de la table CYCLISTE � 00:00:00
	intNb=0
	if Application("blnBDDOracle")=true then	
		Conn.execute "UPDATE CYCLISTE SET DEPART=TO_DATE('00:00:00','HH24:MI:SS'), RETOUR=TO_DATE('00:00:00','HH24:MI:SS')",intNb,adcmdtext
	else
		Conn.execute "UPDATE CYCLISTE SET DEPART='00:00:00', RETOUR='00:00:00'",intNb,adcmdtext
	end if
		
	if intNb<1 then			
		Session("strError")="Erreur lors de l'initialisation des champs DEPART et RETOUR des cyclistes"
		Conn.RollbackTrans
		response.redirect "start.asp"
	end if
	
	'On met � jour le champ d�compte de la course
	intNb=0
	Conn.execute "UPDATE COURSE SET DECOMPTE='Vrai' WHERE NUMCOURSE=" & intNumcourse,intNb,adcmdtext
	
	if intNb<>1 then			
		Session("strError")="Erreur lors de la mise � jour du champs DECOMPTE de la table COURSE"
		Conn.RollbackTrans
		response.redirect "start.asp"		
	end if
	
	'On initialise les autres champs de la COURSE
	Dim strSQL
	strSQL="UPDATE COURSE SET NBPARTICIPANTSTOTAL=0,NBPARTICIPANTSC1=0,NBPARTICIPANTSC2=0,NBPARTICIPANTSC3=0, "
	strSQL=strSQL & "NBRETOURTOTAL=0,NBRETOURC1=0,NBRETOURC2=0,NBRETOURC3=0,"
	strSQL=strSQL & "NB3PARTICIPATIONS=0,NB6PARTICIPATIONS=0,NB9PARTICIPATIONS=0,NB12PARTICIPATIONS=0,NB15PARTICIPATIONS=0 "
	strSQL = strSQL & "WHERE NUMCOURSE=" & intNumcourse
	
	intNb=0
	Conn.execute strSQL,intNb,adcmdtext
	
	if intNb<>1 then			
		Session("strError")="Erreur lors de l'initialisation des champs de la table COURSE"
		Conn.RollbackTrans
		response.redirect "start.asp"		
	end if
	
	
	'Tout s'est bien pass�...
	Conn.CommitTrans
	Session("strError")="Course d�marr�e!"
	response.redirect "index_admin.asp"
	
		
elseif Request.QueryString("action")="stop" then
	'On doit arr�ter la course
	
	'Si DECOMPTE a d�j� "Faux" alors la course a d�j� �t� d�marr�e!
	if strDecompte="Faux" then
		Session("strError")="La course a d�j� eu lieu!"
		Conn.RollbackTrans
		response.redirect "index_admin.asp"		
	end if
	
	'Si DECOMPTE a "" alors la course n'a pas �t� d�marr�e!
	if strDecompte="" then
		Session("strError")="La course n'a pas �t� demarr�e!"
		Conn.RollbackTrans
		response.redirect "index_admin.asp"		
	end if
	
	intNb=0
	Conn.execute "UPDATE COURSE SET DECOMPTE='Faux' WHERE NUMCOURSE=" & intNumcourse,intNb,adcmdtext
	
	if intNb<>1 then			
		Session("strError")="Erreur lors de l'arr�t de la course"
		response.redirect "stop.asp"		
	end if
	
	'Tout s'est bien pass�...
	Conn.CommitTrans
	Session("strError")="Course arr�t�e!"
	response.redirect "index_admin.asp"
	
else
	Conn.RollbackTrans
	Session("strError")="Erreur lors de l'appel de la page de d�marrage/arr�t de la course"
	response.redirect "stop.asp"
end if


%>

<!--#include file="../common/kill.asp"-->