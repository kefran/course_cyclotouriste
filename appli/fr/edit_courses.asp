<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Ajout et modification d'une course
'
'******************************************
%>

<!--#include file="../common/init.asp"-->


<%
'Accès uniquement aux admins
call TestAdmin

if Request.QueryString("mode")<>"new" then
	Dim intNumcourse
	Dim rsCourse
	set rsCourse = Server.CreateObject("ADODB.recordset")
	rsCourse.Open "Select * from COURSE ORDER BY ANNEECOURSE DESC",Conn,adOpenForwardOnly,adLockReadOnly
	if not isEmpty(Request.QueryString("numcourse")) then
		'on doit editer une course particulière
		Dim rsDetailCourse
		set rsDetailCourse = Server.CreateObject("ADODB.recordset")
		rsDetailCourse.Open "Select NUMCOURSE from COURSE where NUMCOURSE=" & Request.QueryString("numcourse") & " ORDER BY ANNEECOURSE DESC",Conn,adOpenForwardOnly,adLockReadOnly
		
		'Test si la course existe
		If rsDetailCourse.EOF Then	
			Session("strError")="La course demandée n'existe pas"
			rsDetailCourse.close
			Set rsDetailCourse = Nothing
			response.redirect "index_admin.asp"
		end if
		
		
		intNumcourse=rsDetailCourse("NUMCOURSE")		
	else
		'Aucun numéro de course n'a été défini => on affiche la dernière course par défaut
		if CInt(NumCourse)=0 then
			'S'il n'existe aucune course dans la BDD=> Erreur
			Session("strError")="Il n'existe aucune course! Veuillez d'abord créer une course."
			rsDetailCourse.close
			Set rsDetailCourse = Nothing
			response.redirect "index_admin.asp"
		end if
		intNumcourse=CInt(NumCourse)
	end if			
	
	'On créé le recordset qui contiendra les données à utiliser pour la course à afficher
	Dim rsDetail
	set rsDetail = Server.CreateObject("ADODB.recordset")
	rsDetail.Open "Select * from COURSE where NUMCOURSE=" & intNumcourse & " ORDER BY ANNEECOURSE DESC",Conn,adOpenForwardOnly,adLockReadOnly
		
end if

%>


<html>
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>

<script type="text/javascript">
function change_course()
{
	var url='edit_courses.asp?numcourse=' + document.form1.numcourse.value; 
	window.location.replace(url);
}

function load()
{
	form1.anneecourse.focus();
}
</script>

<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
<% 
call header
call menu %>
<center>


<%
if Request.QueryString("mode")="new" then
	%>
	<H1>AJOUT D'UNE COURSE</H1>
	<%
else
	%>
	<H1>CONSULTATION DES COURSES</H1>
	
	<%
	
end if

%>


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


	

Tous les champs doivent être renseignés!
<br>
<br>
<table border="0">
<%
if Request.QueryString("mode")="new" then
	%><form name="form1" action="action_edit_courses.asp?mode=add" method="post"><%
else
	%><form name="form1" action="action_edit_courses.asp?mode=modif" method="post"><%
end if
%>

<tr>
<td align=right><b>N° de Course&nbsp;</b></td><td>

<%
if Request.QueryString("mode")="new" then
	%>
	<input type="text" name="numcourse" size="4" maxlength="4" value="<% =CInt(NumCourse)+1 %>" readonly style="background: #e6e6e6; font: bold">
	<%
else
	%>
	<select name="numcourse" onchange="change_course()" style="background: #e6e6e6; font: bold">
	<%
	
		
	Dim intnum
	while not rsCourse.EOF
		intnum=rsCourse("NUMCOURSE")
		if CInt(intnum)=CInt(intNumcourse) then
			response.write("<option value=" & intnum & " selected>" & intnum & " (" & rsCourse("ANNEECOURSE") & ")</option>")	
		else
			response.write("<option value=" & intnum & ">" & intnum & " (" & rsCourse("ANNEECOURSE") & ")</option>")	
		end if
		rsCourse.MoveNext
	Wend
		
	%>
	</select>
	<%
	
end if
%>
<td width="30"></td>
</td><td align=right><b>Année&nbsp;</b></td><td>
<input type="text" name="anneecourse" size="4" maxlength="4" style="font: bold" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("ANNEECOURSE"))
end if
%>
">
<td width="30"></td>
</td><td align=right><b>Date&nbsp;</b></td><td>
<input type="text" name="datecourse" size="11" maxlength="10" style="font: bold" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("DATECOURSE"))
end if
%>
">
jj/mm/aaaa
<td width="30"></td>
</tr>
</table>

<br>
<H3>Distance des circuits</H3>
<table border="0">
<tr>
<td align=right>Circuit 1&nbsp;</td><td>
<input type="text" name="distancec1" size="4" maxlength="4" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("DISTANCEC1"))
end if
%>
">
<td width="30"></td>
</td><td align=right>Circuit 2&nbsp;</td><td>
<input type="text" name="distancec2" size="4" maxlength="4"  value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("DISTANCEC2"))
end if
%>
">
<td width="30"></td>
</td><td align=right>Circuit 3&nbsp;</td><td>
<input type="text" name="distancec3" size="4" maxlength="4"  value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("DISTANCEC3"))
end if
%>
">
<td width="30"></td>
</tr>
</table>


<table border="0">
<tr>
<td>


<%
'Si on est en mode AJOUT D'UNE COURSE, on n'affiche pas
if Request.QueryString("mode")<>"new" then
	%>
	
<br>
<H3>Nombre de participants</H3>
<table border="0">
<tr>
<td align=right><b>Total&nbsp;</b></td><td>
<%
if Request.QueryString("mode")="new" then
	%><input type="text" name="nbparticipantstotal" size="5" readonly maxlength="5" style="background: #e6e6e6" value="<%
else
	%><input type="text" name="nbparticipantstotal" size="5" maxlength="5" style="background: #e6e6e6" value="<%
end if
%>
<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBPARTICIPANTSTOTAL"))
end if
%>
">
</td></tr><tr><td align=right>Circuit 1&nbsp;</td><td>
<input type="text" name="nbparticipantsc1" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBPARTICIPANTSC1"))
end if
%>
">
</td></tr><tr><td align=right>Circuit 2&nbsp;</td><td>
<input type="text" name="nbparticipantsc2" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBPARTICIPANTSC2"))
end if
%>
">
</td></tr><tr><td align=right>Circuit 3&nbsp;</td><td>
<input type="text" name="nbparticipantsc3" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBPARTICIPANTSC3"))
end if
%>
">
</td></tr>
</table>

</td>
<td width="120">
</td>
<td>

<br>
<H3>Nombre de retours</H3>
<table border="0">
<tr>
<td align=right><b>Total&nbsp;</b></td><td>
<%
if Request.QueryString("mode")="new" then
	%><input type="text" name="nbretourtotal" size="5" readonly maxlength="5" style="background: #e6e6e6" value="<%
else
	%><input type="text" name="nbretourtotal" size="5" maxlength="5" style="background: #e6e6e6" value="<%
end if
%>
<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBRETOURTOTAL"))
end if
%>
">
</td></tr><tr><td align=right>Circuit 1&nbsp;</td><td>
<input type="text" name="nbretourc1" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBRETOURC1"))
end if
%>
">
</td></tr><tr><td align=right>Circuit 2&nbsp;</td><td>
<input type="text" name="nbretourc2" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBRETOURC2"))
end if
%>
">
</td></tr><tr><td align=right>Circuit 3&nbsp;</td><td>
<input type="text" name="nbretourc3" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<%
if Request.QueryString("mode")<>"new" then
	response.write(rsDetail("NBRETOURC3"))
end if
%>
">
</td></tr>

	<%
end if
%>
</table>

</td>
</tr>
</table>







<br>
<input type="submit" value="Enregistrer les modifications">
<input type="button" value="Imprimer" onclick="window.print();">
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
</form>

</body>
</html>

<%
if Request.QueryString("mode")<>"new" then
	rsCourse.close
	Set rsCourse = Nothing
	rsDetail.close
	Set rsDetail = Nothing
end if
%>
<!--#include file="../common/kill.asp"-->