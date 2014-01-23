<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Bilan simplifié
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
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>
<center>
<H1>BILAN SIMPLIFIE LA LIONNE</H1>

<%
Dim couleur1,couleur2,coul,intMin,intMax,intNb,intSomme
 dim strCC
couleur1="#DDEAEE"
couleur2="#FBFBFB"
coul="#CCD1E0"
strCC=couleur1
Dim rsCourses
dim rsdoubl
set rsCourses = Server.CreateObject("ADODB.recordset")
set rsdoubl = Server.CreateObject("ADODB.recordset")
rsCourses.Open "SELECT anneecourse, nbparticipantstotal FROM course ORDER BY NUMCOURSE ASC",Conn,adOpenForwardOnly,adLockReadOnly
rsdoubl.Open "SELECT anneecourse, nbparticipantstotal FROM course ORDER BY NUMCOURSE ASC",Conn,adOpenForwardOnly,adLockReadOnly
Dim rsnbann
set rsnbann = Server.CreateObject("ADODB.recordset")
rsnbann.Open "SELECT count(numcourse) as nombre FROM course",Conn,adOpenForwardOnly,adLockReadOnly
response.write(rsnbann("nombre")& " courses")
%>



<table border="0"><br>
<tr>
<td width="20"></td>
<% 

while not rsCourses.EOF
	response.write("<td width=55 bgcolor="&coul&" >" & rsCourses("ANNEECOURSE") & "</td>")	
	rsCourses.MoveNext
Wend
response.write("<td width=55 bgcolor="&coul&" align=right>Mini</td>")
response.write("<td width=55 bgcolor="&coul&" align=right>Maxi</td>")
response.write("<td width=60 bgcolor="&coul&" align=right>Moyenne</td>")
%>

</tr>
   <tr>
   <td width=350  bgcolor="#DDEAEE" > Nombre de participants</td>
   <% 

intMin=9999999
intMax=0
intNb=0
intSomme=0
while not rsdoubl.EOF
	intCompteur=0
	intNb=intNb+1
	response.write("<td width=55 bgcolor="&couleur1&" >" & rsdoubl("nbparticipantstotal") & "</td>")	
	if intMin>CInt(rsdoubl("nbparticipantstotal")) then
		intMin=CInt(rsdoubl("nbparticipantstotal"))
	end if
	intSomme=intSomme+CInt(rsdoubl("nbparticipantstotal"))
	if intMax<CInt(rsdoubl("nbparticipantstotal")) then
		intMax=CInt(rsdoubl("nbparticipantstotal"))
	end if	
	
	rsdoubl.MoveNext
Wend

response.write("<td width=65 bgcolor="&couleur1&" >" & intMin & "</td>")
response.write("<td width=65 bgcolor="&couleur1&" >" & intMax & "</td>")
response.write("<td width=65 bgcolor="&couleur1&" >" & Round(intSomme/intNb) & "</td>")
%>
   </tr>
   
   <tr>
    <td width=350 bgcolor="#FBFBFB">Nombre de nouveaux inscrits</td>
   <%

dim indice
dim suite
dim tmp
suite =""
dim total
total=rsnbann("nombre")
intMin=9999999
intMax=0
intNb=0
intSomme=0
for indice =1 to (CInt(total))
	intCompteur=0
	intNb=intNb+1
	tmp=suite&"1"
	Dim rscompte
	set rscompte = Server.CreateObject("ADODB.recordset")
	rscompte.Open "SELECT count(numcyc) as nombre FROM cycliste where partic like'"&tmp&"%'",Conn,adOpenForwardOnly,adLockReadOnly
	response.write("<td width=55 bgcolor="&couleur2&" >" & rscompte("nombre") & "</td>")
	suite=suite & "0"
	if intMin>CInt(rscompte("nombre")) then
		intMin=CInt(rscompte("nombre"))
	end if
	intSomme=intSomme+CInt(rscompte("nombre"))
	if intMax<CInt(rscompte("nombre")) then
		intMax=CInt(rscompte("nombre"))
	end if
next

response.write("<td width=65 bgcolor="&couleur2&" >" & intMin & "</td>")
response.write("<td width=65 bgcolor="&couleur2&" >" & intMax & "</td>")
response.write("<td width=65 bgcolor="&couleur2&" >" & Round(intSomme/intNb) & "</td>")

%>
   
   </tr>
   <tr>
    <td width=350 bgcolor="#DDEAEE">Participants année précédente pas revenu</td>
   
<%
intMin=9999999
intMax=0
intNb=0
intSomme=0
dim strPartic,intI,intCompteur,strTemp
strPartic=""
Dim rsIns
set rsIns=Server.CreateObject("ADODB.recordset")
Dim strTPartic
response.write("<td width=65 bgcolor="&couleur1&" ></td>")

for intI=2 to (CInt(total))
	intCompteur=0
	intNb=intNb+1
	rsIns.Open "SELECT PARTIC FROM CYCLISTE",Conn,adOpenForwardOnly,adLockReadOnly
	while not rsIns.EOF
		if Mid(rsIns("PARTIC"),intI-1,2)="10" then
			intCompteur=intCompteur+1
		end if		
		rsIns.MoveNext			
	Wend  
	response.write("<td width=65 bgcolor="&couleur1&" >" & intCompteur & "</td>")
	if intMin>intCompteur then
		intMin=intCompteur
	end if
	intSomme=intSomme+intCompteur
	if intMax<intCompteur then
		intMax=intCompteur
	end if
	rsIns.Close
Next
response.write("<td width=65 bgcolor="&couleur1&" >" & intMin & "</td>")
response.write("<td width=65 bgcolor="&couleur1&" >" & intMax & "</td>")
response.write("<td width=65 bgcolor="&couleur1&" >" & Round(intSomme/intNb) & "</td>")

%>
</tr>
<tr>
<td height=20></td>
</tr>

</table>


<br><br>
<br>

<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
</body>
</html>

<!--#include file="../common/kill.asp"-->





