<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin

Dim intNumcourse

'On récupère le numéro de la dernière course pour lesquelles les départs seront considérés
Dim rsCourse
set rsCourse = Server.CreateObject("ADODB.recordset")
rsCourse.Open "Select MAX(NUMCOURSE) as NB from COURSE",Conn,adOpenForwardOnly,adLockReadOnly
if rsCourse.EOF then
	Session("strError")="Aucune course n'a été crée!"
	response.redirect "index_admin.asp"
else
	intNumcourse=CInt(rsCourse("NB"))
end if
rsCourse.close

'On récupère le nombre de courses existantes
rsCourse.Open "Select COUNT(*) AS NB FROM COURSE",Conn,adOpenForwardOnly,adLockReadOnly
Dim intNbcourses
intNbcourses=rsCourse("NB")
rsCourse.close


'On cherche les distances des différents circuits
Dim strDC1,strDC2,strDC3
rsCourse.Open "Select DISTANCEC1,DISTANCEC2,DISTANCEC3 from COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
strDC1=rsCourse("DISTANCEC1")
strDC2=rsCourse("DISTANCEC2")
strDC3=rsCourse("DISTANCEC3")
rsCourse.close


'On cherche le nombre de personnes parties
Dim strDepC1,strDepC2,strDepC3,strDepTotal
rsCourse.Open "Select count(*) AS NBDepC1 from PARTICIPER WHERE NUMCIRCUIT=1 AND NUMCOURSE=" & intNumcourse & " AND HDEPART IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strDepC1=rsCourse("NBDepC1")
rsCourse.close

rsCourse.Open "Select count(*) AS NBDepC2 from PARTICIPER WHERE NUMCIRCUIT=2 AND NUMCOURSE=" & intNumcourse & " AND HDEPART IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strDepC2=rsCourse("NBDepC2")
rsCourse.close

rsCourse.Open "Select count(*) AS NBDepC3 from PARTICIPER WHERE NUMCIRCUIT=3 AND NUMCOURSE=" & intNumcourse & " AND HDEPART IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strDepC3=rsCourse("NBDepC3")
rsCourse.close

rsCourse.Open "Select count(*) AS NBDepTotal from PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND HDEPART IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strDepTotal=rsCourse("NBDepTotal")
rsCourse.close




'On cherche le nombre de personnes arrivées
Dim strArrC1,strArrC2,strArrC3,strArrTotal
rsCourse.Open "Select count(*) AS NBArrC1 from PARTICIPER WHERE NUMCIRCUIT=1 AND NUMCOURSE=" & intNumcourse & " AND HARRIVEE IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strArrC1=rsCourse("NBArrC1")
rsCourse.close

rsCourse.Open "Select count(*) AS NBArrC2 from PARTICIPER WHERE NUMCIRCUIT=2 AND NUMCOURSE=" & intNumcourse & " AND HARRIVEE IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strArrC2=rsCourse("NBArrC2")
rsCourse.close

rsCourse.Open "Select count(*) AS NBArrC3 from PARTICIPER WHERE NUMCIRCUIT=3 AND NUMCOURSE=" & intNumcourse & " AND HARRIVEE IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strArrC3=rsCourse("NBArrC3")
rsCourse.close

rsCourse.Open "Select count(*) AS NBArrTotal from PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND HARRIVEE IS NOT NULL",Conn,adOpenForwardOnly,adLockReadOnly
strArrTotal=rsCourse("NBArrTotal")
rsCourse.close



'On cherche le nombre de personnes concernées par les récompenses
Dim str3p,str6p,str9p,str12p,str15p,str18p,str21p,str24p,str27p,str30p
rsCourse.Open "Select NB3PARTICIPATIONS,NB6PARTICIPATIONS,NB9PARTICIPATIONS,NB12PARTICIPATIONS,NB15PARTICIPATIONS,NB18PARTICIPATIONS,NB21PARTICIPATIONS,NB24PARTICIPATIONS,NB27PARTICIPATIONS,NB30PARTICIPATIONS FROM COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
str3p=rsCourse("NB3PARTICIPATIONS")
str6p=rsCourse("NB6PARTICIPATIONS")
str9p=rsCourse("NB9PARTICIPATIONS")
str12p=rsCourse("NB12PARTICIPATIONS")
str15p=rsCourse("NB15PARTICIPATIONS")
str18p=rsCourse("NB18PARTICIPATIONS")
str21p=rsCourse("NB21PARTICIPATIONS")
str24p=rsCourse("NB24PARTICIPATIONS")
str27p=rsCourse("NB27PARTICIPATIONS")
str30p=rsCourse("NB30PARTICIPATIONS")
rsCourse.close


'On recherche le nom des récompenses
rsCourse.Open "Select * FROM RECOMPENSE ORDER BY NbParticipation ASC",Conn,adOpenForwardOnly,adLockReadOnly
Dim strKDO1,strKDO2,strKDO3,strKDO4,strKDO5,strKDO6,strKDO7,strKDO8,strKDO9,strKDO10
strKDO1=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO2=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO3=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO4=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO5=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO6=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO7=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO8=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO9=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
strKDO10=rsCourse("LIBRECOMPENSE")
rsCourse.MoveNext
rsCourse.close



%>

<html>
<head>

<%
if request.querystring("refresh")="True" then
%>

<script>
<!--

//enter refresh time in "minutes:seconds" Minutes should range from 0 to inifinity. Seconds should range from 0 to 59
var limit="0:05"

if (document.images){
var parselimit=limit.split(":")
parselimit=parselimit[0]*60+parselimit[1]*1
}
function beginrefresh(){
if (!document.images)
return
if (parselimit==1)
window.location.reload()
else{ 
parselimit-=1
curmin=Math.floor(parselimit/60)
cursec=parselimit%60
if (curmin!=0)
curtime=curmin+" minutes and "+cursec+" seconds left until page refresh!"
else
curtime=cursec+" secondes avant rafraichissement de la fenêtre 'Suivi de la course'"
window.status=curtime
setTimeout("beginrefresh()",1000)
}
}

//window.onload=beginrefresh
//-->
</script>

<%
end if
%>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<center>
<h1>SUIVI DE LA COURSE</h1>


<%
' Affichage de l'erreur le cas échéant

if Session("strError")<>"" then
%>

<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>


<% end if 
Session("strError")="" %>


<table border="0" cellpadding="2" summary="">
	<tr>
		<td></td>
		<td>Circuit 1</td>
		<td>Circuit 2</td>
		<td>Circuit 3</td>
		<td></td>
	</tr>
	<tr>
		<td height="24">Distance</td>
		<td height="24"><input type="text" name="distc1" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDC1 %>"></td>
		<td height="24"><input type="text" name="distc2" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDC2 %>"></td>
		<td height="24"><input type="text" name="distc3" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDC3 %>"></td>
		<td width=5></td>
		<td height="24">Total</td>
	</tr>
	<tr>
		<td>Départ</td>
		<td><input type="text" name="depc1" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepC1 %>"></td>
		<td><input type="text" name="depc2" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepC2 %>"></td>
		<td><input type="text" name="depc3" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepC3 %>"></td>
		<td width=5></td>
		<td><input type="text" name="deptotal" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepTotal %>"></td>
	</tr>
	<tr>
		<td>Arrivée</td>
		<td><input type="text" name="arrivc1" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrC1 %>"></td>
		<td><input type="text" name="arrivc2" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrC2 %>"></td>
		<td><input type="text" name="arrivc3" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrC3 %>"></td>
		<td width=5></td>
		<td><input type="text" name="arrivtotal" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrTotal %>"></td>
	</tr>
</table>

<br>
<H3>Suivi des récompenses</H3>


<table border="0" summary="">
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td>Libellé de la récompense</td>
		<td width="5"></td>
		<td>Nombre</td>
	</tr>
	<%	if intNbcourses>=3 then %>
	<tr>
		<td width="140" height="24">Pour 3 Participations</td>
		<td width="5" height="24"></td>
		<td height="24"><input type="text" size="40" maxlength="45" maxlength="3" readonly style="background: #e6e6e6" value="<% =strKDO1 %>"></td>
		<td width="5" height="24"></td>
		<td height="24"><input type="text" name="3p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str3p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=6 then %>
	<tr>
		<td width="140">Pour 6 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO2 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="6p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str6p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=9 then %>
	<tr>
		<td width="140">Pour 9 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO3 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="9p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str9p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=12 then %>
	<tr>
		<td width="140">Pour 12 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO4 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="12p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str12p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=15 then %>
	<tr>
		<td width="140">Pour 15 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO5 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="15p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str15p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=18 then %>
	<tr>
		<td width="140">Pour 18 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO6 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="18p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str18p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=21 then %>
	<tr>
		<td width="140">Pour 21 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO7 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="21p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str21p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=24 then %>
	<tr>
		<td width="140">Pour 24 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO8 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="24p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str24p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=27 then %>
	<tr>
		<td width="140">Pour 27 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO9 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="27p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str27p %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% end if %>
	<%	if intNbcourses>=30 then %>
	<tr>
		<td width="140">Pour 30 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="3p" size="40" maxlength="45" readonly style="background: #e6e6e6" value="<% =strKDO10 %>"></td>
		<td width="5"></td>
		<td><input type="text" name="30p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str30p %>"></td>
	</tr>
	<% end if %>
</table>

<br><br>
<input type="button" value="Imprimer" onclick="window.print();">
<input type="button" value="Rafraîchir" onclick="window.location.reload();">
<input type="button" value="Retour à l'accueil" onclick="parent.window.location.replace('index_admin.asp');">
</center>
</body>
</html>
<%
set rsCourse=Nothing
%>
<!--#include file="../common/kill.asp"-->