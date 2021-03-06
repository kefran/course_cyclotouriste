<!--#include file="../common/init.asp"-->

<%
'Acc�s uniquement aux admins
call TestAdmin

Dim intNumcourse

'On r�cup�re le num�ro de la derni�re course pour lesquelles les d�parts seront consid�r�s
Dim rsCourse
set rsCourse = Server.CreateObject("ADODB.recordset")
rsCourse.Open "Select MAX(NUMCOURSE) as NB from COURSE",Conn,adOpenForwardOnly,adLockReadOnly
if rsCourse.EOF then
	Session("strError")="Aucune course n'a �t� cr�e!"
	response.redirect "index_admin.asp"
else
	intNumcourse=CInt(rsCourse("NB"))
end if
rsCourse.close

'On r�cup�re le nombre de courses existantes
rsCourse.Open "Select COUNT(*) AS NB FROM COURSE",Conn,adOpenForwardOnly,adLockReadOnly
Dim intNbcourses
intNbcourses=rsCourse("NB")
rsCourse.close


'On cherche les distances des diff�rents circuits
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




'On cherche le nombre de personnes arriv�es
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



'On cherche le nombre de personnes concern�es par les r�compenses
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



'On r�cup�re les infos sur la course courante
Set rsCourse = Server.CreateObject("ADODB.recordset")
rsCourse.Open "SELECT * FROM COURSE WHERE NUMCOURSE=" & NumCourse(),Conn,adOpenForwardOnly,adLockReadOnly
if rsCourse.EOF then
	Session("strError")="Impossible d'obtenir les informations de la course courante"
	response.redirect "../fr/index_admin.asp"
end if

Dim strDatecourse,strAnneecourse
strDatecourse=rsCourse("DATECOURSE")
strAnneecourse=rsCourse("ANNEECOURSE")

rsCourse.close

%>

<html>
<head>

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
curtime=cursec+" secondes avant rafraichissement de la fen�tre 'Suivi de la course'"
window.status=curtime
setTimeout("beginrefresh()",1000)
}
}

//window.onload=beginrefresh
//-->
</script>

<SCRIPT LANGUAGE="JavaScript">

var Compteur = null; 
var CompteurTourne = false;

function DemarreHorloge () { 
  if(CompteurTourne) 
  clearTimeout(Compteur); 
  CompteurTourne = false; 
  AfficheTemps(); 
  } 

function AfficheTemps () { 
  var Temps = new Date(); 
  var TempsLocal = Temps.getTime()+ (Temps.getTimezoneOffset()-60)*60; 
  var Maintenant = new Date(TempsLocal); 
  var Heure = " " + Maintenant.getHours(); 
  var minutes = Maintenant.getMinutes(); 
  var secondes = Maintenant.getSeconds(); 
  Heure += ((minutes < 10) ? ":0" : ":") + minutes; 
  Heure += ((secondes < 10) ? ":0" : ":") + secondes; 
  document.Horloge.FenetreHeure.value = Heure; 
  var AujourdHui = " " + Maintenant.getDate(); 
  var Mois = Maintenant.getMonth()+1; 
  var Annee = Maintenant.getYear(); 
  AujourdHui += "/" + Mois + "/" + Annee; 
  Compteur = setTimeout("AfficheTemps()",1000); 
  CompteurTourne = true; 
  }
// -->
</SCRIPT>

<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body onload="DemarreHorloge()">
<center>
<h3><font color="#d48729"><b>SUIVI DE LA COURSE</b></font></h3>

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
		<td>D�part</td>
		<td><input type="text" name="depc1" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepC1 %>"></td>
		<td><input type="text" name="depc2" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepC2 %>"></td>
		<td><input type="text" name="depc3" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepC3 %>"></td>
		<td width=5></td>
		<td><input type="text" name="deptotal" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strDepTotal %>"></td>
	</tr>
	<tr>
		<td>Arriv�e</td>
		<td><input type="text" name="arrivc1" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrC1 %>"></td>
		<td><input type="text" name="arrivc2" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrC2 %>"></td>
		<td><input type="text" name="arrivc3" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrC3 %>"></td>
		<td width=5></td>
		<td><input type="text" name="arrivtotal" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% =strArrTotal %>"></td>
	</tr>
</table>


<table border="0">
<%	if intNbcourses>=3 then %>
	<tr>
		<td width="105"></td>
		<td>3p</td>
		<%	if intNbcourses>=6 then %>
		<td>6p</td>
		<% end if %>
		<%	if intNbcourses>=9 then %>
		<td>9p</td>
		<% end if %>
		<%	if intNbcourses>=12 then %>
		<td>12p</td>
		<% end if %>
		<%	if intNbcourses>=15 then %>
		<td>15p</td>
		<% end if %>
	</tr>
	<% end if %>
	<%	if intNbcourses>=3 then %>
	<tr>
		<td width="105">R�compenses</td>
		<td><input type="text" name="3p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str3p %>"></td>
		<%	if intNbcourses>=6 then %>
		<td><input type="text" name="6p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str6p %>"></td>
		<% end if %>
		<%	if intNbcourses>=9 then %>
		<td><input type="text" name="9p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str9p %>"></td>
		<% end if %>
		<%	if intNbcourses>=12 then %>
		<td><input type="text" name="12p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str12p %>"></td>
		<% end if %>
		<%	if intNbcourses>=15 then %>
		<td><input type="text" name="15p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str15p %>"></td>
		<% end if %>
	</tr>
	<% end if %>
	<%	if intNbcourses>=18 then %>
	<tr>
		<td width="105"></td>
		<td>18p</td>
		<%	if intNbcourses>=21 then %>
		<td>21p</td>
		<% end if %>
		<%	if intNbcourses>=24 then %>
		<td>24p</td>
		<% end if %>
		<%	if intNbcourses>=27 then %>
		<td>27p</td>
		<% end if %>
		<%	if intNbcourses>=30 then %>
		<td>30p</td>
		<% end if %>
	</tr>
	<% end if %>
	<%	if intNbcourses>=18 then %>
	<tr>
		<td></td>
		<td><input type="text" name="18p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str18p %>"></td>
		<%	if intNbcourses>=21 then %>
		<td><input type="text" name="21p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str21p %>"></td>
		<% end if %>
		<%	if intNbcourses>=24 then %>
		<td><input type="text" name="24p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str24p %>"></td>
		<% end if %>
		<%	if intNbcourses>=27 then %>
		<td><input type="text" name="27p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str27p %>"></td>
		<% end if %>
		<%	if intNbcourses>=30 then %>
		<td><input type="text" name="30p" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% =str30p %>"></td>
		<% end if %>
	</tr>
	<% end if %>
</table>
<hr>
<FORM name="Horloge" onSubmit="0">
Course de la Lionne �dition <b><% =strAnneecourse %></b> du <% =DateConvert(strDatecourse) %>
&nbsp;&nbsp;
<INPUT type="text" name="FenetreHeure" size="8" maxlength="8" style="font: bold" align="middle">
</FORM>


</center>
</body>
</html>
<%
set rsCourse=Nothing
%>
<!--#include file="../common/kill.asp"-->