<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Affiche toutes les courses existantes
'
'******************************************
%>


<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin

Dim strSQL
strSQL="Select * from COURSE "

if Request.querystring("tri")="num_asc" then
	strSQL=strSQL & "ORDER BY NUMCOURSE ASC"
end if

if Request.querystring("tri")="num_desc" or Request.querystring("tri")="" then
	strSQL=strSQL & "ORDER BY NUMCOURSE DESC"
end if

if Request.querystring("tri")="date_asc" then
	strSQL=strSQL & "ORDER BY DATECOURSE ASC"
end if

if Request.querystring("tri")="date_desc" then
	strSQL=strSQL & "ORDER BY DATECOURSE DESC"
end if

if Request.querystring("tri")="annee_asc" then
	strSQL=strSQL & "ORDER BY ANNEECOURSE ASC"
end if

if Request.querystring("tri")="annee_desc" then
	strSQL=strSQL & "ORDER BY ANNEECOURSE DESC"
end if

if Request.querystring("tri")="total_asc" then
	strSQL=strSQL & "ORDER BY NBPARTICIPANTSTOTAL ASC"
end if

if Request.querystring("tri")="total_desc" then
	strSQL=strSQL & "ORDER BY NBPARTICIPANTSTOTAL DESC"
end if

%>


<html>
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>

<script type="text/javascript">
function supprimer_course(numcourse)
{
	if (confirm('Etes-vous sur de vouloir supprimer la course numéro '+ numcourse + '?')==true){
	var url='action_supprimer_course.asp?numcourse=' + numcourse; 
	window.location.replace(url);
	}
}
</script>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>
<center>
<H1>LISTE DE TOUTES LES COURSES</H1>

<%

Dim rsCourses
set rsCourses = Server.CreateObject("ADODB.recordset")

rsCourses.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
%>


<table border="0"><br>
<tr>
<td width="20"></td>
<!-- <td width="20"></td> -->
<td width="110" bgcolor="#CCD1E0"><b>Numéro&nbsp;<a href="liste_courses.asp?tri=num_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_courses.asp?tri=num_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="100" bgcolor="#CCD1E0"><b>Date&nbsp;<a href="liste_courses.asp?tri=date_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_courses.asp?tri=date_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="100" bgcolor="#CCD1E0"><b>Année&nbsp;<a href="liste_courses.asp?tri=annee_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_courses.asp?tri=annee_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="100" bgcolor="#CCD1E0"><b>Total&nbsp;<a href="liste_courses.asp?tri=total_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_courses.asp?tri=total_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="85" bgcolor="#CCD1E0"><b>Circuit 1&nbsp;</b></td>
<td width="85" bgcolor="#CCD1E0"><b>Circuit 2&nbsp;</b></td>
<td width="85" bgcolor="#CCD1E0"><b>Circuit 3&nbsp;</b></td>
</tr>
   
 
  
<%
Dim nbligne
Dim strLigne
Dim strCC
Dim couleur1,couleur2
couleur1="#DDEAEE"
couleur2="#FBFBFB"
nbligne=1


while not rsCourses.EOF
	if (nbligne mod 2)=0 then
		strCC=couleur1
	else
		strCC=couleur2
	end if
	nbligne=nbligne+1

	response.write("<tr>")	
	strLigne="<td width=20 bgcolor=" & strCC & " align=center><a href=edit_courses.asp?numcourse=" & rsCourses("NUMCOURSE") & "><img src=../common/images/modif.png border=0  alt=Modifier la course></a></td>"
	response.write(strLigne)
	'strLigne="<td width=20 bgcolor=" & strCC & " align=center><a href=# onclick=supprimer_course(" & rsCourses("NUMCOURSE") & ")><img src=../common/images/supprimer.png border=0  alt=Supprimer la course></a></td>"
	'response.write(strLigne)
	response.write("<td width=110 bgcolor=" & strCC & ">" & rsCourses("NUMCOURSE") & "</td>")
	response.write("<td width=100 bgcolor=" & strCC & ">" & rsCourses("DATECOURSE") & "</td>")
	response.write("<td width=100 bgcolor=" & strCC & ">" & rsCourses("ANNEECOURSE") & "</td>")
	response.write("<td width=100 bgcolor=" & strCC & ">" & rsCourses("NBPARTICIPANTSTOTAL") & "</td>")
	response.write("<td width=85 bgcolor=" & strCC & ">" & rsCourses("NBPARTICIPANTSC1") & "</td>")
	response.write("<td width=85 bgcolor=" & strCC & ">" & rsCourses("NBPARTICIPANTSC2") & "</td>")
	response.write("<td width=85 bgcolor=" & strCC & ">" & rsCourses("NBPARTICIPANTSC3") & "</td>")	
	response.write("</tr>")
	rsCourses.MoveNext
	%>
	
	
	<%
Wend


%>
</table>

<br>
<input type="button" value="Imprimer" onclick="window.print();">
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
</body>
</html>

<%
rsCourses.close
Set rsCourses=Nothing
%>
<!--#include file="../common/kill.asp"-->






