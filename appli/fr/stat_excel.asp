<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Bilan global au format MS EXCEL
'
'******************************************
%>

<!--#include file="../Common/init.asp"-->

<% Response.ContentType = "application/vnd.ms-excel" %>


<html>
<body>


<%
Dim couleur1,couleur2,coul
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

%>

</tr>
   <tr>
   <td width=350  bgcolor="#DDEAEE" > Nombre de participants cette année là</td>
   <% 

while not rsdoubl.EOF
	response.write("<td width=55 bgcolor="&couleur1&" >" & rsdoubl("nbparticipantstotal") & "</td>")	
	rsdoubl.MoveNext
	Wend

%>
   </tr>
   
   <tr>
    <td width=350 bgcolor="#FBFBFB">Nombre de nouveaux inscrits cette année là</td>
   <%

dim indice
dim suite
dim tmp
suite =""
dim total
total=rsnbann("nombre")
for indice =1 to (CInt(total))
tmp=suite&"1"
Dim rscompte
set rscompte = Server.CreateObject("ADODB.recordset")
rscompte.Open "SELECT count(numcyc) as nombre FROM cycliste where partic like'"&tmp&"%'",Conn,adOpenForwardOnly,adLockReadOnly
response.write("<td width=55 bgcolor="&couleur2&" >" & rscompte("nombre") & "</td>")
suite=suite & "0"
next

%>
   
   </tr>
   <tr>
    <td width=350 bgcolor="#DDEAEE">Nombre de noms dans la liste cette année là</td>
   
   <%

dim indiceb
dim suiteb
dim tmpb
suiteb =""
dim part
part=0
for indiceb =1 to (CInt(total))
tmpb=suiteb&"1"
Dim rscompt
set rscompt = Server.CreateObject("ADODB.recordset")
rscompt.Open "SELECT count(numcyc) as nombre FROM cycliste where partic like'"&tmpb&"%'",Conn,adOpenForwardOnly,adLockReadOnly
part=part+CInt(rscompt("nombre"))
response.write("<td width=65 bgcolor="&couleur1&" >" & part & "</td>")
suiteb=suiteb & "0"
next

%>
</tr>
<tr>
<td height=20></td>
</tr>


 <%
strCC=couleur1	
 Dim deuxdim(50, 50)
 dim test
 dim number
dim pos
dim tr
dim ptr
Dim rsparti
set rsparti = Server.CreateObject("ADODB.recordset")
rsparti.Open "SELECT partic FROM cycliste",Conn,adOpenForwardOnly,adLockReadOnly
'response.write("<td width=65 bgcolor="&coul&" >" & part & "</td>")
while not rsparti.EOF
ptr=rsparti("partic")
number=0
for pos =0 to 15
test=left(ptr,1)
if test="1" then
number=number+1
deuxdim(pos,(number-1))=deuxdim(pos,(number-1))+1
end if
ptr=mid(ptr,2)
'deuxdim(pos,pos)=pos
next
rsparti.MoveNext
Wend
for pos =0 to (CInt(total)-1)
if strCC=couleur2 then
		strCC=couleur1
	else
		strCC=couleur2
	end if
if pos=0 then
response.write("<tr><td width=250 bgcolor="&strCC&" >Nombre d'inscrits ayant "& (pos+1)& " participation</td>")
else
response.write("<tr><td width=250 bgcolor="&strCC&" >Nombre d'inscrits ayant "& (pos+1)& " participations</td>")
end if
for tr =0 to (CInt(total)-1)
response.write("<td width=40 bgcolor="&strCC&" >" & deuxdim(tr,pos) & "</td>")
next
response.write("</tr>")
next
%>
</table>














</BODY>
</HTML>
<!--#include file="../common/kill.asp"-->