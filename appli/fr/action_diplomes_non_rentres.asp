<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Impression de tous les dipl�mes des cyclistes non rentr�s
'
'******************************************
%>

<!--#include file="../common/init.asp"-->
<%
'Acc�s uniquement aux admins
call TestAdmin


Dim rsDiplome
set rsDiplome = Server.CreateObject("ADODB.recordset")

Dim intNumcyc

'On r�cup�re le num�ro de course courant	
Dim intNumcourse
intNumcourse=NumCourse()

Dim strSQL,ArrCyclistes,intNbcyc,i
strSQL="SELECT COUNT(NUMCYC) AS NB FROM CYCLISTE WHERE DERNUMCOURSE=" & intNumcourse & " AND DEPART <>0 AND( RETOUR IS NULL OR RETOUR=0)"
rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
intNbcyc=rsDiplome("NB")
rsDiplome.close


strSQL="SELECT NUMCYC FROM CYCLISTE WHERE DERNUMCOURSE=" & intNumcourse & " AND DEPART <>0 AND( RETOUR IS NULL OR RETOUR=0) ORDER BY NOM,PRENOM,NUMCYC ASC"
rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly

if rsDiplome.EOF then
	'Pas de coureurs non rentr�s, la course est d�j� clotur�e
	Session("strError")=Session("strError") & "<br><br><br>TOUS LES COUREURS SONT ARRIVES! AUCUN DIPLOME A IMPRIMER"
	response.redirect "diplomes.asp"
end if

ArrCyclistes=rsDiplome.GetRows
rsDiplome.close




for i=0 to intNbcyc-1
	
	if i=0 then
		'On formate le document HTML
		%>
		<html>
			<head>
				<link href="../style.css" rel="stylesheet" type="text/css">
			</head>
			<body onload="window.print();">
				<center>
			<%
	end if
	
	intNumcyc=ArrCyclistes(0,i)
	
	'On v�rifie que le cycliste existe
	Dim strNom,strPrenom,strPolit,strNbcourses
	strSQL="SELECT * FROM CYCLISTE WHERE NUMCYC=" & intNumcyc
	rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
	if rsDiplome.EOF then
		Session("strError")="Une erreur est survenue!"
		response.redirect "diplomes.asp"
	end if
	strNom=rsDiplome("NOM")
	strPrenom=rsDiplome("PRENOM")
	strPolit=rsDiplome("POLIT")
	strNbcourses=rsDiplome("NBCOURSES")
	rsDiplome.close
	
	'On trouve � quelle course la personne a particip�
	Dim intNumcircuit
	strSQL="SELECT NUMCIRCUIT FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc
	rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
	if rsDiplome.EOF then
		Session("strError")="Une erreur est survenue: Le cycliste demand� n'a pas pris le d�part de la derni�re course!"
		response.redirect "diplomes.asp"
	end if
	intNumcircuit=CInt(rsDiplome("NUMCIRCUIT"))
	rsDiplome.close
	
	'On r�cup�re les infos sur la course courante
	Dim strDistance, strAnneecourse, strDatecourse
	strSQL="SELECT DATECOURSE,ANNEECOURSE,DISTANCEC" & intNumcircuit & " AS KM FROM COURSE WHERE NUMCOURSE=" & intNumcourse
	rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
	if rsDiplome.EOF then
		Session("strError")="Erreur lors de la recherche de la course courante!"
		response.redirect "diplomes.asp"
	end if
	strDistance=rsDiplome("KM")
	strAnneecourse=rsDiplome("ANNEECOURSE")
	strDatecourse=rsDiplome("DATECOURSE")
	rsDiplome.close
	
	Dim strTitre,strCorps
	strSQL="SELECT * FROM DIPLOME WHERE ID=1"
	rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
	if rsDiplome.EOF then
		Session("strError")="Erreur lors du chargement des donn�es de la table DIPLOME!"
		response.redirect "diplomes.asp"
	end if
	strTitre=rsDiplome("TITRE")
	strCorps=rsDiplome("CORPS")
	strTitre=unescape(strTitre)
	strCorps=unescape(strCorps)
	rsDiplome.close
	
	strTitre=ConvertTextDiplome(strTitre,strNom,strPrenom,strPolit,strAnneecourse,strDatecourse,strDistance,intNumcircuit,strNbcourses)
	strCorps=ConvertTextDiplome(strCorps,strNom,strPrenom,strPolit,strAnneecourse,strDatecourse,strDistance,intNumcircuit,strNbcourses)
	%>
			<% =strTitre %>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<% =strCorps %>
			<br>
			<br>
			<br>
			<br>
			
			
			<%
	
next


%>
			<br>
			<br>
		</center>
	</body>
</html>
<%

set rsDiplome=Nothing 
%>
<!--#include file="../common/kill.asp"-->