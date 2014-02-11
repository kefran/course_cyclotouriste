<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Fichier ex�cutant les modifications sur la course
'
'******************************************
%>



<!--#include file="../common/init.asp"-->


<%
'Acc�s uniquement aux admins
call TestAdmin

%>

<html>
<head>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>

<%


'V�rification des donn�es re�ues
Dim strPB,blnPB
strPB=""
blnPb=false

'ANNEECOURSE
if not isNumeric(request.form("ANNEECOURSE")) then
	Session("strError")=Session("strError") & "L'ann�e doit �tre un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("ANNEECOURSE")))<>4 then
	Session("strError")=Session("strError") & "L'ann�e doit �tre compos�e de 4 chiffres<br>"
	blnPb=true
end if

'DATECOURSE
if not isdate(request.form("DATECOURSE")) then
	Session("strError")=Session("strError") & "La date doit �tre de la forme jj/mm/aaaa<br>"
	blnPb=true
else
	if Year(CDate(request.form("DATECOURSE")))<>CInt(request.form("ANNEECOURSE")) then
		Session("strError")=Session("strError") & "La date de la course et l'ann�e de la course doivent �tre identiques<br>"
		blnPb=true
	end if
end if

'On v�rifie que le total des participants donn� est valide
if request.querystring("mode")="modif" then
	if not isNumeric(request.form("NBPARTICIPANTSTOTAL")) then
		Session("strError")=Session("strError") & "Le nombre de participants total doit �tre un nombre<br>"
		blnPb=true
	end if
end if

'On v�rifie que le total des retours donn� est valide
if request.querystring("mode")="modif" then
	if not isNumeric(request.form("NBRETOURTOTAL")) then
		Session("strError")=Session("strError") & "Le nombre de retours total doit �tre un nombre<br>"
		blnPb=true
	end if
end if


	
	
'On v�rifie que l'ann�e donn�e est bien l'ann�e courante
if request.querystring("mode")="add" then
	if not isNumeric(request.form("ANNEECOURSE")) then
		Session("strError")=Session("strError") & "L'ann�e de la course doit �tre un chiffre<br>"
		blnPb=true
	else
		if CInt(request.form("ANNEECOURSE"))<>Year(Now()) then
			Session("strError")=Session("strError") & "Vous ne pouvez entrer une course que pour l'ann�e en cours<br>"
			blnPb=true
		end if
	
		Dim rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open "SELECT NUMCOURSE FROM COURSE WHERE ANNEECOURSE=" & request.form("ANNEECOURSE"), Conn
		if not rs.EOF then
			Session("strError")=Session("strError") & "Une course a d�j� eu lieu en " & request.form("ANNEECOURSE") & ".<br>"
			blnPb=true
		end if
		rs.Close
		Set rs= Nothing	
	end if
end if

'DISTANCEC1
if not isNumeric(request.form("DISTANCEC1")) then
	Session("strError")=Session("strError") & "La distance de la course 1 doit �tre un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("DISTANCEC1")))>4 then
	Session("strError")=Session("strError") & "La distance de la course 1 ne doit pas �tre compos�e de plus de 4 chiffres<br>"
	blnPb=true
end if

'DISTANCEC2
if not isNumeric(request.form("DISTANCEC2")) then
	Session("strError")=Session("strError") & "La distance de la course 2 doit �tre un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("DISTANCEC2")))>4 then
	Session("strError")=Session("strError") & "La distance de la course 2 ne doit pas �tre compos�e de plus de 4 chiffres<br>"
	blnPb=true
end if

'DISTANCEC3
if not isNumeric(request.form("DISTANCEC3")) then
	Session("strError")=Session("strError") & "La distance de la course 3 doit �tre un nombre<br>"
	blnPb=true
end if

if CInt(Len(request.form("DISTANCEC3")))>4 then
	Session("strError")=Session("strError") & "La distance de la course 3 ne doit pas �tre compos�e de plus de 4 chiffres<br>"
	blnPb=true
end if



if blnPb=false then
	'Les modifications sont effectu�es dans le cadre d une transaction
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
	
		
		
		'On doit mettre � NULL tous les champs DEPART et RETOUR de tous les cyclistes
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
	Session("strError")="Course ajout�e!"
	response.redirect "index_admin.asp"
else
	Session("strError")="Course modifi�e!"
	response.redirect "edit_courses.asp?mode=edit"
end if


%>



<center>


</center>
</body>
</html>
<!--#include file="../common/kill.asp"-->