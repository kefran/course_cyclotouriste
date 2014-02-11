<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Fichier exécutant les modifications sur la course
'
'******************************************
%>



<!--#include file="../common/init.asp"-->


<%
'Accès uniquement aux admins
call TestAdmin

%>

<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>

<%


'Vérification des données reçues
Dim strPB,blnPB
strPB=""
blnPb=false

'ANNEECOURSE
if not isNumeric(request.form("ANNEECOURSE")) then
	Session("strError")=Session("strError") & "L'année doit être un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("ANNEECOURSE")))<>4 then
	Session("strError")=Session("strError") & "L'année doit être composée de 4 chiffres<br>"
	blnPb=true
end if

'DATECOURSE
if not isdate(request.form("DATECOURSE")) then
	Session("strError")=Session("strError") & "La date doit être de la forme jj/mm/aaaa<br>"
	blnPb=true
else
	if Year(CDate(request.form("DATECOURSE")))<>CInt(request.form("ANNEECOURSE")) then
		Session("strError")=Session("strError") & "La date de la course et l'année de la course doivent être identiques<br>"
		blnPb=true
	end if
end if

'On vérifie que le total des participants donné est valide
if request.querystring("mode")="modif" then
	if not isNumeric(request.form("NBPARTICIPANTSTOTAL")) then
		Session("strError")=Session("strError") & "Le nombre de participants total doit être un nombre<br>"
		blnPb=true
	end if
end if

'On vérifie que le total des retours donné est valide
if request.querystring("mode")="modif" then
	if not isNumeric(request.form("NBRETOURTOTAL")) then
		Session("strError")=Session("strError") & "Le nombre de retours total doit être un nombre<br>"
		blnPb=true
	end if
end if


	
	
'On vérifie que l'année donnée est bien l'année courante
if request.querystring("mode")="add" then
	if not isNumeric(request.form("ANNEECOURSE")) then
		Session("strError")=Session("strError") & "L'année de la course doit être un chiffre<br>"
		blnPb=true
	else
		if CInt(request.form("ANNEECOURSE"))<>Year(Now()) then
			Session("strError")=Session("strError") & "Vous ne pouvez entrer une course que pour l'année en cours<br>"
			blnPb=true
		end if
	
		Dim rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open "SELECT NUMCOURSE FROM COURSE WHERE ANNEECOURSE=" & request.form("ANNEECOURSE"), Conn
		if not rs.EOF then
			Session("strError")=Session("strError") & "Une course a déjà eu lieu en " & request.form("ANNEECOURSE") & ".<br>"
			blnPb=true
		end if
		rs.Close
		Set rs= Nothing	
	end if
end if

'DISTANCEC1
if not isNumeric(request.form("DISTANCEC1")) then
	Session("strError")=Session("strError") & "La distance de la course 1 doit être un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("DISTANCEC1")))>4 then
	Session("strError")=Session("strError") & "La distance de la course 1 ne doit pas être composée de plus de 4 chiffres<br>"
	blnPb=true
end if

'DISTANCEC2
if not isNumeric(request.form("DISTANCEC2")) then
	Session("strError")=Session("strError") & "La distance de la course 2 doit être un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("DISTANCEC2")))>4 then
	Session("strError")=Session("strError") & "La distance de la course 2 ne doit pas être composée de plus de 4 chiffres<br>"
	blnPb=true
end if

'DISTANCEC3
if not isNumeric(request.form("DISTANCEC3")) then
	Session("strError")=Session("strError") & "La distance de la course 3 doit être un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("DISTANCEC3")))>4 then
	Session("strError")=Session("strError") & "La distance de la course 3 ne doit pas être composée de plus de 4 chiffres<br>"
	blnPb=true
end if



if blnPb=false then
	'Les modifications sont effectuées dans le cadre d une transaction
	Conn.BeginTrans
	Conn.CommandTimeOut=120

	if Request.QueryString("mode")="add" then
		'On doit ajouter une nouvelle course
		
		Dim strSQL,strDate
		strDate=request.form("DATECOURSE")
		strDate =replace(strDate,"/","-")
		strDate=Mid(strDate,4,2) & "-" & Mid(strDate,1,2) & "-" & Mid(strDate,7,4)
		strSQL="INSERT INTO COURSE VALUES "
		if Application("blnBDDOracle")=true then		
			strSQL=strSQL & " (" & request.form("NUMCOURSE") & ",'" & strDate & "'," & request.form("ANNEECOURSE")
		else
			strSQL=strSQL & " (" & request.form("NUMCOURSE") & ",#" & strDate & "#," & request.form("ANNEECOURSE")
		end if
		strSQL=strSQL & ",0,0,0,0,0,0,0,0," & request.form("DISTANCEC1") & "," & request.form("DISTANCEC2") & "," 
		strSQL=strSQL & request.form("DISTANCEC3") & ",NULL,0,0,0,0,0,0,0,0,0,0)"
		Dim intNb
		response.write(strSQL)
		Conn.execute strSQL,intNb,adcmdtext
		
				
		if intNb<>1 then
			Conn.RollbackTrans
			%>
			
			<center><br><b><font color="#ff0000">ERREUR LORS DE L'AJOUT DE LA COURSE</font></b><br><br></center>
			<%
		else
			%>
			
			<%
		end if
	
		
		
		'On doit mettre à NULL tous les champs DEPART et RETOUR de tous les cyclistes
		strSQL="UPDATE CYCLISTE SET DEPART=NULL, RETOUR=NULL"
		Conn.execute strSQL,intNb,adcmdtext
		if intNb<1 then
			Conn.RollbackTrans
			%>
			
			<center><br><b><font color="#ff0000">ERREUR LORS DE LA MISE A JOUR DES CYCLISTES (champs DEPART et RETOUR)</font></b><br><br></center>
			<%
		end if
		
		
		%>
		<center><br><b><font color="#0000FF">AJOUT DE LA COURSE EFFECTUE</font></b><br><br></center>
		<%
		Conn.CommitTrans
		
		
			
	elseif Request.QueryString("mode")="modif" then
		'On doit modifier une course existante
		
		Dim strSQL2,strDate2
		strDate2=request.form("DATECOURSE")
		strDate2 =replace(strDate2,"/","-")
		strDate2=Mid(strDate2,4,2) & "-" & Mid(strDate2,1,2) & "-" & Mid(strDate2,7,4)
		strSQL2="UPDATE COURSE SET "
		strSQL2=strSQL2 & "DISTANCEC1 =" & request.form("DISTANCEC1")
		strSQL2=strSQL2 & ", DISTANCEC2 =" & request.form("DISTANCEC2")
		strSQL2=strSQL2 & ", DISTANCEC3 =" & request.form("DISTANCEC3")
		if Application("blnBDDOracle")=true then		
			strSQL2=strSQL2 & ", DATECOURSE ='" & strDate2 & "'"
		else
			strSQL2=strSQL2 & ", DATECOURSE =#" & strDate2 & "#"
		end if
		strSQL2=strSQL2 & ", ANNEECOURSE =" & request.form("ANNEECOURSE")
		strSQL2=strSQL2 & ", NBPARTICIPANTSTOTAL =" & request.form("NBPARTICIPANTSTOTAL")
		strSQL2=strSQL2 & ", NBRETOURTOTAL =" & request.form("NBRETOURTOTAL")
		strSQL2=strSQl2 & " WHERE NUMCOURSE=" & request.form("NUMCOURSE")
		Dim intNb2
		Conn.execute strSQL2,intNb2,adcmdtext
		
		if intNb2<>1 then
			Conn.RollbackTrans
			%>
			
			<center><br><b><font color="#ff0000">ERREUR LORS DE LA MISE A JOUR</font></b><br><br></center>
			<%
		else
		Conn.CommitTrans
			%>
			
			<center><br><b><font color="#0000FF">MISE A JOUR EFFECTUEE AVEC SUCCES</font></b><br><br></center>
			<%
		end if
	end if
else
	if request.querystring("mode")="add" then
		response.redirect "edit_courses.asp?mode=new"
	else
		response.redirect "edit_courses.asp?mode=edit"
	end if
end if

if request.querystring("mode")="add" then
	Session("strError")="Course ajoutée!"
	response.redirect "index_admin.asp"
else
	Session("strError")="Course modifiée!"
	response.redirect "edit_courses.asp?mode=edit"
end if


%>



<center>


</center>
</body>
</html>
<!--#include file="../common/kill.asp"-->