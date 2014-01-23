<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Impression du dipl�me d�un cycliste
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
if request.querystring("numcyc")>0 then
	intNumcyc=request.querystring("numcyc")
else
	Session("strError")="Le num�ro de cycliste demand� n'est pas correct!"
	response.redirect "diplomes.asp"
end if

'On v�rifie que le cycliste existe
Dim strSQL,strNom,strPrenom,strPolit,strNbcourses
strSQL="SELECT * FROM CYCLISTE WHERE NUMCYC=" & intNumcyc
rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
if rsDiplome.EOF then
	Session("strError")="Le cycliste demand� n'existe pas!"
	response.redirect "diplomes.asp"
end if
strNom=rsDiplome("NOM")
strPrenom=rsDiplome("PRENOM")
strPolit=rsDiplome("POLIT")
strNbcourses=rsDiplome("NBCOURSES")
rsDiplome.close

'On r�cup�re le num�ro de course courant	
Dim intNumcourse
intNumcourse=NumCourse()

'On trouve � quelle course la personne a particip�
Dim intNumcircuit
strSQL="SELECT NUMCIRCUIT FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc
rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
if rsDiplome.EOF then
	Session("strError")="Le cycliste demand� n'a pas pris le d�part de la derni�re course!"
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

strTitre=ConvertTextDiplome(strTitre,strNom,strPrenom,strPolit,strAnneecourse,strDatecourse,strDistance,intNumcircuit,strNbcourses)
strCorps=ConvertTextDiplome(strCorps,strNom,strPrenom,strPolit,strAnneecourse,strDatecourse,strDistance,intNumcircuit,strNbcourses)

%>


<html>
<head>
<link href="../style.css" rel="stylesheet" type="text/css">

</head>
<body onload="window.print();">
<center>

	<% =strTitre %>
	<br><br><br><br><br><br>
	<% =strCorps %>

	

<br><br>
</center>
</body>
</html>
<%
set rsDiplome=Nothing 
%>

<!--#include file="../common/kill.asp"-->