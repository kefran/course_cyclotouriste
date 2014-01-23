<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


Dim rsCourse
set rsCourse = Server.CreateObject("ADODB.recordset")

'On récupère le nombre de courses existantes
rsCourse.Open "Select COUNT(*) AS NB FROM COURSE",Conn,adOpenForwardOnly,adLockReadOnly
Dim intNbcourses
intNbcourses=rsCourse("NB")
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
<% call menu_head %>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>
<center>

<h1>SUIVI DE LA COURSE</h1>


<%
' Affichage de l'erreur le cas échéant

if Session("strError")<>"" then
%>
<br>
<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>
<br><br>

<% end if 
Session("strError")="" %>
<br>

<br><br>
<H3>Suivi des récompenses</H3>

<form name="form1" action="action_rewards.asp" method="post">
<table border="0" summary="">
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td>Libellé de la récompense</td>
	</tr>
	<%	if intNbcourses>=3 then %>
	<tr>
		<td width="140" height="24">Pour 3 Participations</td>
		<td width="5" height="24"></td>
		<td height="24"><input type="text" name="3p" size="40" maxlength="45" maxlength="3" value="<% =strKDO1 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="3p" size="40" maxlength="45" maxlength="3" value="<% =strKDO1 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=6 then %>
	<tr>
		<td width="140">Pour 6 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="6p" size="40" maxlength="45" value="<% =strKDO2 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="6p" size="40" maxlength="45" maxlength="3" value="<% =strKDO2 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=9 then %>
	<tr>
		<td width="140">Pour 9 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="9p" size="40" maxlength="45" value="<% =strKDO3 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="9p" size="40" maxlength="45" maxlength="3" value="<% =strKDO3 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=12 then %>
	<tr>
		<td width="140">Pour 12 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="12p" size="40" maxlength="45" value="<% =strKDO4 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="12p" size="40" maxlength="45" maxlength="3" value="<% =strKDO4 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=15 then %>
	<tr>
		<td width="140">Pour 15 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="15p" size="40" maxlength="45" value="<% =strKDO5 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="15p" size="40" maxlength="45" maxlength="3" value="<% =strKDO5 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=18 then %>
	<tr>
		<td width="140">Pour 18 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="18p" size="40" maxlength="45" value="<% =strKDO6 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="18p" size="40" maxlength="45" maxlength="3" value="<% =strKDO6 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=21 then %>
	<tr>
		<td width="140">Pour 21 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="21p" size="40" maxlength="45" value="<% =strKDO7 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="21p" size="40" maxlength="45" maxlength="3" value="<% =strKDO7 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=24 then %>
	<tr>
		<td width="140">Pour 24 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="24p" size="40" maxlength="45" value="<% =strKDO8 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="24p" size="40" maxlength="45" maxlength="3" value="<% =strKDO8 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=27 then %>
	<tr>
		<td width="140">Pour 27 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="27p" size="40" maxlength="45" value="<% =strKDO9 %>"></td>
	</tr>
	<tr>
		<td width="140"></td>
		<td width="5"></td>
		<td></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="27p" size="40" maxlength="45" maxlength="3" value="<% =strKDO9 %>"></td>
	</tr>
	<% end if %>
	
	<% if intNbcourses>=30 then %>
	<tr>
		<td width="140">Pour 30 Participations</td>
		<td width="5"></td>
		<td><input type="text" name="30p" size="40" maxlength="45" value="<% =strKDO10 %>"></td>
	</tr>
	<% else %>
	<tr>
		<td><input type="hidden" name="30p" size="40" maxlength="45" maxlength="3" value="<% =strKDO10 %>"></td>
	</tr>
	<% end if %>
	
</table>

<br>
<input type="submit" value="Enregistrer">
<input type="button" value="Annuler les modifications" onclick="location.reload();">
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
</form>
</center>
</body>
</html>

<!--#include file="../common/kill.asp"-->