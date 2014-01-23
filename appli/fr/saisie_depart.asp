<!--#include file="../common/init.asp"-->

<%


'Accès uniquement aux admins
call TestAdmin

Dim intNumcyc
Dim intNumcourse
Dim blnNoMdif

blnNoMdif=false

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


rsCourse.Open "Select DECOMPTE from COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
if isNull(rsCourse("DECOMPTE")) then
	Session("strError")="La course n'a pas été démarrée! Vous ne pouvez donc pas saisir de départs."
	response.redirect "index_admin.asp"
elseif rsCourse("DECOMPTE")="Faux" then
	Session("strError")="La course a déjà eu lieu! Vous devez créer une nouvelle course pour pouvoir saisir des départs."
	response.redirect "index_admin.asp"
end if

rsCourse.close

set rsCourse=Nothing



'On test les valeurs passées en paramètres
if not isNumeric(request.querystring("search")) then
	Session("strError")="Le numéro de coureur ne doit contenir que des chiffres"
	response.redirect "saisie_depart.asp"
end if

if request.querystring("search")>0 then
	Dim rsSearch
	set rsSearch = Server.CreateObject("ADODB.recordset")
	rsSearch.Open "Select NUMCYC from CYCLISTE WHERE NUMCYC=" & request.querystring("search"),Conn,adOpenForwardOnly,adLockReadOnly
	if rsSearch.EOF then
		Session("strError")="Le cycliste recherché n'existe pas"
		response.redirect "saisie_depart.asp"
	else
		intNumcyc=request.querystring("search")
	end if
	rsSearch.close
	set rsSearch=Nothing
end if
	


if request.querystring("numcyc")>0 then
	intNumcyc=request.querystring("numcyc")
else
	if intNumcyc<1 then
		intNumcyc=0
	end if
end if


'On créé le recordset qui contiendra toutes les valeurs qui seront utilisées
Dim rsCyc
set rsCyc = Server.CreateObject("ADODB.recordset")

%>

<html>
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>

<script type="text/javascript">

function chercher_cycliste(num) { 
	if (num!="")
	{
  	var url='saisie_depart.asp?search=' + num; 
		window.location.replace(url);
	}
} 


function change_cycliste()
{
	var url='saisie_depart.asp?numcyc=' + document.form0.cbnom.value; 
	window.location.replace(url);
}




</script>

<link href="../style.css" rel="stylesheet" type="text/css">

</head>
<body>
<% 
call header
call menu %>



<center>
<H1>SAISIE DES DEPARTS</H1>



<%
' Affichage de l'erreur le cas échéant

if Session("strError")<>"" then
%>

<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>


<% end if 
Session("strError")="" %>


<form name="form0" action="search_saisie_depart.asp" method="post">

<% 
if (intNumcyc>0 and blnNoMdif=false) then
	%>
	<input type="button" value="Enregister le départ" onclick="document.form1.submit();">
	<%
else
	%>
	<input type="button" value="Enregister le départ" disabled>
	<%
end if
%>

<% 
if intNumcyc>0 then
	%>
	<input type="button" value="Modifier le cycliste" onclick="window.location.replace('edit_cycliste.asp?from=depart&mode=edit&numedit=<% =intNumcyc %>');">
	<%
else
	%>
	<input type="button" value="Modifier le cycliste" disabled>
	<%
end if
%>
<input type="button" value="Ajouter un cycliste" onclick="window.location.replace('edit_cycliste.asp?mode=new&from=depart');">	
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">


<table border="0">
	<tr>
		<td align=left><H3>Recherche</H3>
		<b>
		N° de cycliste:&nbsp;
		<input type="text" name="num" size="4" maxlength="5">
		<input type="submit" value="Ok" onclick="var num=document.forms[0].num.value; chercher_cycliste(num);">
		&nbsp;&nbsp;
		Nom:
		<select name="cbnom" onchange="change_cycliste()" style="background:#e6e6e6; font: bold">
		<option value="0">- - - - - - - - - - - - - -</option>
		<%
		if Application("blnBDDOracle")=true then
			rsCyc.Open "Select * from CYCLISTE WHERE (DEPART=TO_DATE('00:00:00','HH24:MI:SS') OR DEPART IS NULL) ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		else
			rsCyc.Open "Select * from CYCLISTE WHERE (DEPART=#00:00:00# OR DEPART IS NULL) ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
			'rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC NOT IN (SELECT NUMCYC FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & ") ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		end if
		
		
		'rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC NOT IN (SELECT NUMCYC FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & ") ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		Dim intnum
		while not rsCyc.EOF		
			intnum=rsCyc("NUMCYC")
			if CInt(intnum)=CInt(intNumcyc) then
				response.write("<option value=" & rsCyc("NUMCYC") & " selected>" & rsCyc("NOM") & " - " & rsCyc("PRENOM") & " - " & rsCyc("NUMCYC") & "</option>")
			else
				response.write("<option value=" & rsCyc("NUMCYC") & " >" & rsCyc("NOM") & " - " & rsCyc("PRENOM") & " - " & rsCyc("NUMCYC") & "</option>")	
			end if
		
			rsCyc.MoveNext	
		Wend
		
		rsCyc.close
		%>
				
		</select>		
		</b>
		
		</form>
		<form name="form1" action="action_saisie_depart.asp" method="post">
		<input type="hidden" name="cbnom" value="<% =intNumcyc %>">
		<H3>Course</H3>
		<b>
		Circuit:&nbsp;&nbsp;
		
		
		<%
		rsCyc.Open "Select * FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
		Dim intNBC,strHDEPART
		if rsCyc.EOF then
			intNBC=0
			strHDEPART=""
		else
			intNBC=CInt(rsCyc("NUMCIRCUIT"))
			strHDEPART=DateConvert(rsCyc("HDEPART"))
		end if
		
		if strHDEPART<>"" then
			blnNoMdif=true
		end if
		
		rsCyc.close
		
		
		rsCyc.Open "Select DISTANCEC1,DISTANCEC2,DISTANCEC3 from COURSE WHERE NUMCOURSE=" & intNumcourse,Conn,adOpenForwardOnly,adLockReadOnly
		%>
		</b>
	
		<input type="radio" name="numcircuit" value="1" <% if intNBC=1 then
		response.write("checked")
		end if%>		
		> <% =rsCyc("DISTANCEC1") %>km
		<input type="radio" name="numcircuit" value="2" <% if intNBC=2 then
		response.write("checked")
		end if%>		
		>  <% =rsCyc("DISTANCEC2") %>km
		<input type="radio" name="numcircuit" value="3"  <% if intNBC=3 then
		response.write("checked")
		end if%>		
		> <% =rsCyc("DISTANCEC3") %>km
		<b>
		
		
		&nbsp;&nbsp;
		Départ:&nbsp;&nbsp;
		<input type="text" name="hdepart" size="8" maxlength="8" readonly style="background: #e6e6e6" value="<% =strHDEPART	%>">
		<%
		rsCyc.close
		rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
		%>
		<br>
		
		</b>
		Nombre de participations:&nbsp;&nbsp;
		<input type="text" name="nbparticip" size="2" maxlength="2" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("NBCOURSES")) 
		end if%>" >
		
		&nbsp;&nbsp;&nbsp;&nbsp;
		Participations:
		<input type="text" name="nbcourses" size="25" maxlength="25" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("PARTIC")) 
		end if%>" >
		
		<br>
		N° ASCAP:
		<input type="text" name="ascap" size="7" maxlength="7" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("ASCAP")) 
		end if%>" >
		&nbsp;&nbsp;
		
		Catégorie:
		
		<select name="cat" style="background:#e6e6e6" disabled>
		<%
		Dim rsCat
		Set rsCat=Server.CreateObject("ADODB.recordset")
		rsCat.Open "Select * from TLISTES WHERE NOMLISTE='CATEGORIE' ORDER BY VALELT ASC",Conn,adOpenForwardOnly,adLockReadOnly
		Dim str,strCyc
		
		if rsCyc.EOF then
			strCyc=""
		else
			strCyc=rsCyc("CAT")
		end if
			
		while not rsCat.EOF		
			str=rsCat("VALELT")
			if str=strCyc then
				response.write("<option value=" & rsCat("NUMELT") & " selected>" & rsCat("VALELT") & "</option>")
			else
				response.write("<option value=" & rsCat("NUMELT") & ">" & rsCat("VALELT") & "</option>")
			end if
		
			rsCat.MoveNext	
		Wend
		
		rsCat.close
		set rsCat= Nothing
		%>
				
		</select>	
		
				
		<H3>Identité</H3>
		N° cycliste:
		<input type="text" name="numcyc" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("NUMCYC")) 
		end if%>" >
		&nbsp;&nbsp;
		Nom:
		<input type="text" name="nom" size="15" maxlength="25" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("NOM")) 
		end if%>" >
		&nbsp;&nbsp;
		Prénom:
		<input type="text" name="prenom" size="15" maxlength="20" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("PRENOM")) 
		end if%>" >
		&nbsp;&nbsp;
		<br>
		Politesse:
		<select name="polit" style="background:#e6e6e6" disabled>
		
		<option value="M" <% if not rsCyc.EOF then 
		if rsCyc("POLIT")="M" then
		response.write("selected") 
		end if
		end if%>
		> M</option>
		<option value="MME" <% if not rsCyc.EOF then 
		if rsCyc("POLIT")="MME" then
		response.write("selected") 
		end if
		end if%>
		> Mme</option>
		<option value="MLLE" <% if not rsCyc.EOF then 
		if rsCyc("POLIT")="MLLE" then
		response.write("selected") 
		end if
		end if%>
		> Mlle</option>
		</select>
		&nbsp;&nbsp;
		
		<input type="radio" name="sexe" value="M" disabled
		<% if not rsCyc.EOF then 
		if rsCyc("SEXE")="M" then
		response.write("checked") 
		end if
		end if%>
		> Homme
		<input type="radio" name="sexe" value="F" disabled
		<% if not rsCyc.EOF then 
		if rsCyc("SEXE")="F" then
		response.write("checked") 
		end if
		end if%>
		> Femme
		&nbsp;&nbsp;
		
		Date de naissance:
		<input type="text" name="date_n" size="10" maxlength="10" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("DATE_N")) 
		end if%>" >
				
		<br><br>
		N° et rue:
		<input type="text" name="adresse" size="45" maxlength="35" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("ADRESSE")) 
		end if%>" >
		&nbsp;&nbsp;
		<br>
		Code postal:
		<input type="text" name="cod_post" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("COD_POST")) 
		end if%>" >
		&nbsp;&nbsp;
		Ville:
		<input type="text" name="ville" size="25" maxlength="25" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("VILLE")) 
		end if%>" >
		&nbsp;&nbsp;
		<br>
		Usine:
		<input type="text" name="usine" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("USINE")) 
		end if%>" >
		&nbsp;&nbsp;
		Adresse usine:
		<input type="text" name="adr_usi" size="23" maxlength="20" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("ADR_USI")) 
		end if%>" >
		&nbsp;&nbsp;
		</td>
		<td WIDTH=50></td>
		<td align=right><IFRAME name=suivi align=right src="suivi_course.asp" WIDTH=330 HEIGHT=315 SCROLLING=NO FRAMEBORDER=1></IFRAME></td>
	</tr>
</table>


<% 
if (intNumcyc>0 and blnNoMdif=false) then
	%>
	<input type="submit" value="Enregister le départ" >
	<%
else
	%>
	<input type="button" value="Enregister le départ" disabled>
	<%
end if
%>

<% 
if intNumcyc>0 then
	%>
	<input type="button" value="Modifier le cycliste" onclick="window.location.replace('edit_cycliste.asp?from=depart&mode=edit&numedit=<% =intNumcyc %>');">
	<%
else
	%>
	<input type="button" value="Modifier le cycliste" disabled>
	<%
end if
%>
<input type="button" value="Ajouter un cycliste" onclick="window.location.replace('edit_cycliste.asp?mode=new&from=depart');">	
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
</form>
</center>
<script type="text/javascript">
document.form0.num.focus();
</script>

</body>
</html>
<!--#include file="../common/kill.asp"-->