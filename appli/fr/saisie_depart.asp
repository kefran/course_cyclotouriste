<!--#include file="../common/init.asp"-->

<?php
phpinfo();
?>

<%


'Accès uniquement aux admins
call TestAdmin

Dim intNumcyc
Dim intNumcourse
Dim blnNoMdif

blnNoMdif=false

'On créé le recordset qui contiendra toutes les valeurs qui seront utilisées
Dim rsCyc
set rsCyc = Server.CreateObject("ADODB.recordset")

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
		'si ajax demande un cycliste on répond directement
		
		rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
		
		response.write(rsCyc("ADRESSE")&"|"&rsCyc("ADR_USI")&"|"&rsCyc("ASCAP")&"|"&rsCyc("CAT")&"|"&rsCyc("COD_POST"))
		response.write("|"&rsCyc("DATE_N")&"|"&rsCyc("DEPART")&"|"&rsCyc("NBCOURSES")&"|"&rsCyc("NOM")&"|"&rsCyc("NUMCYC"))
		response.write("|"&rsCyc("PARTIC")&"|"&rsCyc("POLIT")&"|"&rsCyc("PRENOM")&"|"&rsCyc("SEXE")&"|"&rsCyc("USINE"))
		response.write("|"&rsCyc("VILLE"))

		rsCyc.Close
		response.end
		
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


%>

<html>
<head>
<% call menu_head %>
<title>Site des gestion de la course de la LIONNE</title>
<script src="../common/xhr.js" ></script>
<script type="text/javascript">

function chercher_cycliste(num) { 
	if (num!="")
	{
  	var url='saisie_depart.asp?search=' + num; 
		window.location.replace(url);
	}
} 

function getCycliste(el){
var numcyc=el.value;
var xhr = createXHR();
var data="?search="+el.value;

		xhr.open('GET','saisie_depart.asp'+data,true);
		xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhr.onreadystatechange= function()
		{	
			if(xhr.readyState==4 && xhr.status==200)
			{
				setCycliste(xhr.responseText.split("|"));
			}
		}
		
		xhr.send();
}

function setCycliste(res)
{
/*
		rsCyc("ADRESSE") 0
		rsCyc("ADR_USI") 1 
		rsCyc("ASCAP") 2
		rsCyc("CAT") 3
		rsCyc("COD_POST") 4
		rsCyc("DATE_N") 5
		rsCyc("DEPART") 6
		rsCyc("NBCOURSES") 7
		rsCyc("NOM") 8
		rsCyc("NUMCYC")) 9
		rsCyc("PARTIC") 10
		rsCyc("POLIT") 11
		rsCyc("PRENOM") 12
		rsCyc("SEXE") 13
		rsCyc("USINE")) 14
		rsCyc("VILLE"))15
*/
	document.form0.num.value="";

	
	document.form0.cbnom.value=0;
	document.form1.c1.checked=false;
	document.form1.c2.checked=false;
	document.form1.c3.checked=false;
	
	document.form1.hdepart.value=res[6];
	document.form1.nbparticip.value=res[7];
	document.form1.nbcourses.value=res[8];
	document.form1.ascap.value=res[2];
	document.form1.cat.value="";
	document.form1.numcyc.value=res[9];
	document.form1.nom.value=res[8];
	document.form1.prenom.value=res[12];
	document.form1.polit.selectedIndex=((res[11]=="M")?0:(res[11]=="MME")?1:2);
	document.form1.M.checked=(res[13]=='M')?true:false;
	document.form1.F.checked=(res[13]=='F')?true:false;
	document.form1.date_n.value=res[5];
	document.form1.adresse.value="";
	document.form1.cod_post.value=res[4];
	document.form1.ville.value=res[15];
	document.form1.usine.value=res[14];
	document.form1.adr_usi.value=res[1];
	
	document.form0.addDepart.disabled=true;
	document.form0.addDepart1.disabled=true;
	document.form1.addDepart2.disabled=true;
	
	document.form0.modCyc.disabled=true;
	document.form1.modCyc1.disabled=true;

}
function change_cycliste()
{
	var url='saisie_depart.asp?numcyc=' + document.form0.cbnom.value; 
	window.location.replace(url);
}

function ajaxSubmit()
{
	var xhr = createXHR();
	var data ="cbnom=";
	data+=document.getElementById('cbnom').value;
	C1=document.getElementById('c1').checked;
	C2=document.getElementById('c2').checked;
	C3=document.getElementById('c3').checked;
	data+="&numcircuit=";
	data+=((C1)?"1":((C2)?"2":((C3)?"3":"")));
	data+="&ajax=1";
			
		xhr.open('POST','action_saisie_depart.asp',true);
		xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhr.onreadystatechange= function()
		{	
			if(xhr.readyState==4 && xhr.status==200)
			{
				res=xhr.responseText.split("|");
				if(res[0]=="OK")
				{
					document.getElementById('message').innerHTML=res[1];	
					cleanForm();
				}
				else
				{
					document.getElementById('message').innerHTML=xhr.responseText;
				}	
			}
		}
		
		xhr.send(data);
}
function cleanForm()
{
	
	document.form0.num.value="";
	document.form0.cbnom.remove(document.form0.cbnom.selectedIndex);
	
	document.form0.cbnom.value=0;
	document.form1.c1.checked=false;
	document.form1.c2.checked=false;
	document.form1.c3.checked=false;
	
	document.form1.hdepart.value="";
	document.form1.nbparticip.value="";
	document.form1.nbcourses.value="";
	document.form1.ascap.value="";
	document.form1.cat.value="";
	document.form1.numcyc.value="";
	document.form1.nom.value="";
	document.form1.polit.value=0;
	document.form1.M.checked=false;
	document.form1.F.checked=false;
	document.form1.date_n.value="";
	document.form1.adresse.value="";
	document.form1.cod_post.value="";
	document.form1.ville.value="";
	document.form1.usine.value="";
	document.form1.adr_usi.value="";
	
/*	document.form0.addDepart.disabled=true;
	document.form0.addDepart1.disabled=true;
	document.form1.addDepart2.disabled=true;
	
	document.form0.modCyc.disabled=true;
	document.form1.modCyc1.disabled=true;
	
	document.form0.num.focus();
	*/

}

</script>

<link href="../style.css" rel="stylesheet" type="text/css">
<link href="../bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css" />
</head>
<body>
<% 
call header
call menu
 %>

<center>
<H1>SAISIE DES DEPARTS</H1>


<b><font color="#ff0000"><div id="message" name="message"></div>


<% =Session("strError") %>

<% Session("strError")="" %>

</font></b>

<form name="form0" action="search_saisie_depart.asp" method="post">

<% 
if (intNumcyc>0 and blnNoMdif=false) then
	%>
	<input type="button" id="addDepart" value="Enregister le départ" onclick="document.form1.submit();"></input>
	<input type="button" id="addDepart1" value="Enregister le départ (ajax)" onclick="ajaxSubmit();"></input>
	<%
else
	%>
	<input type="button" id="addDepart" value="Enregister le départ" disabled></input>
	<%
end if
%>

<% 
if intNumcyc>0 then
	%>
	<input type="button" id="modCyc" value="Modifier le cycliste" onclick="window.location.replace('edit_cycliste.asp?from=depart&mode=edit&numedit=<% =intNumcyc %>');"></input>
	<%
else
	%>
	<input type="button" value="Modifier le cycliste" disabled></input>
	<%
end if
%>
<input type="button" value="Ajouter un cycliste" onclick="window.location.replace('edit_cycliste.asp?mode=new&from=depart');">	</input>
<input class="btn" type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');"></input>
<input class="btn btn-primary" type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');"></input>
<input class="btn btn-primary" type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');"></input>


<table border="0">
	<tr>
		<td align=left><H3>Recherche</H3>
		<b>
		N° de cycliste:&nbsp;
		<input type="text" name="num" id="num" size="4" maxlength="5"></input>
		<input type="submit" value="Ok" onclick="var num=document.forms[0].num.value; chercher_cycliste(num);"></input>
		&nbsp;&nbsp;
		Nom:
		<select name="cbnom" id="cbnom" onchange="change_cycliste()" style="background:#e6e6e6; font: bold">
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
		
		<select name="cbnom1" id="cbnom1" onchange="getCycliste(this);" style="background:#e6e6e6; font: bold">
		<option value="0">- - - - - - - - - - - - - -</option>
		<%
		if Application("blnBDDOracle")=true then
			rsCyc.Open "Select * from CYCLISTE WHERE (DEPART=TO_DATE('00:00:00','HH24:MI:SS') OR DEPART IS NULL) ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		else
			rsCyc.Open "Select * from CYCLISTE WHERE (DEPART=#00:00:00# OR DEPART IS NULL) ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
			'rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC NOT IN (SELECT NUMCYC FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & ") ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		end if
		
		
		'rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC NOT IN (SELECT NUMCYC FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & ") ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		'Dim intnum
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
		<input type="hidden" name="cbnom" id="value" value="<% =intNumcyc %>"></input>
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
	
		<input type="radio" name="numcircuit" id="c1" value="1" <% if intNBC=1 then
		response.write("checked")
		end if%>		
		> <% =rsCyc("DISTANCEC1") %></input>km
		<input type="radio" name="numcircuit" id="c2" value="2" <% if intNBC=2 then
		response.write("checked")
		end if%>		
		>  <% =rsCyc("DISTANCEC2") %></input>km
		<input type="radio" name="numcircuit" id="c3" value="3"  <% if intNBC=3 then
		response.write("checked")
		end if%>		
		> <% =rsCyc("DISTANCEC3") %></input>km
		<b>
		
		
		&nbsp;&nbsp;
		Départ:&nbsp;&nbsp;
		<input type="text" name="hdepart" id="hdepart" size="8" maxlength="8" readonly style="background: #e6e6e6" value="<% =strHDEPART	%>"></input>
		<%
		rsCyc.close
		rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
		%>
		<br>
		
		</b>
		Nombre de participations:&nbsp;&nbsp;
		<input type="text" name="nbparticip" id="nbparticip" size="2" maxlength="2" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("NBCOURSES")) 
		end if%>" ></input>
		
		&nbsp;&nbsp;&nbsp;&nbsp;
		Participations:
		<input type="text" name="nbcourses" id="nbcourses" size="25" maxlength="25" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("PARTIC")) 
		end if%>" ></input>
		
		<br>
		N° ASCAP:
		<input type="text"  id="ascap" name="ascap" size="7" maxlength="7" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("ASCAP")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		
		Catégorie:
		
		<select name="cat" id="cat" style="background:#e6e6e6" disabled>
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
		<input type="text" name="numcyc" id="numcyc" size="3" maxlength="3" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("NUMCYC")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		Nom:
		<input type="text" name="nom" id="nom" size="15" maxlength="25" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("NOM")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		Prénom:
		<input type="text" name="prenom" id="prenom" size="15" maxlength="20" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("PRENOM")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		<br>
		Politesse:
		<select name="polit" id="polit" style="background:#e6e6e6" disabled>
		
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
		
		<input type="radio" name="sexe" id="M" value="M" disabled
		<% if not rsCyc.EOF then 
		if rsCyc("SEXE")="M" then
		response.write("checked") 
		end if
		end if%>
		> Homme</input>
		<input type="radio" name="sexe" id="F" value="F" disabled
		<% if not rsCyc.EOF then 
		if rsCyc("SEXE")="F" then
		response.write("checked") 
		end if
		end if%>
		> Femme</input>
		&nbsp;&nbsp;
		
		Date de naissance:
		<input type="text" name="date_n" id="date_n" size="10" maxlength="10" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("DATE_N")) 
		end if%>" ></input>
				
		<br><br>
		N° et rue:
		<input type="text" name="adresse" id="adresse" size="45" maxlength="35" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("ADRESSE")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		<br>
		Code postal:
		<input type="text" name="cod_post" id="cod_post" size="5" maxlength="5" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("COD_POST")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		Ville:
		<input type="text" name="ville" id="ville" size="25" maxlength="25" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("VILLE")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		<br>
		Usine:
		<input type="text" name="usine" id="usine" size="4" maxlength="4" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("USINE")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		Adresse usine:
		<input type="text" name="adr_usi" id="adr_usi" size="23" maxlength="20" readonly style="background: #e6e6e6" value="<% if not rsCyc.EOF then 
		response.write(rsCyc("ADR_USI")) 
		end if%>" ></input>
		&nbsp;&nbsp;
		</td>
		<td WIDTH=50></td>
		<!-- <td align=right><IFRAME name=suivi align=right src="suivi_course.asp" WIDTH=330 HEIGHT=315 SCROLLING=NO FRAMEBORDER=1></IFRAME></td> -->
	</tr>
</table>


<% 
if (intNumcyc>0 and blnNoMdif=false) then
	%>
	<input type="submit" id="addDepart2" value="Enregister le départ" ></input>
	<%
else
	%>
	<input type="button" id="addDepart2" value="Enregister le départ" disabled></input>
	<%
end if
%>

<% 
if intNumcyc>0 then
	%>
	<input type="button" id="modCyc1" value="Modifier le cycliste" onclick="window.location.replace('edit_cycliste.asp?from=depart&mode=edit&numedit=<% =intNumcyc %>');"></input>
	<%
else
	%>
	<input type="button" id="modCyc1" value="Modifier le cycliste" disabled></input>
	<%
end if
%>
<input type="button" id="addCycliste" value="Ajouter un cycliste" onclick="window.location.replace('edit_cycliste.asp?mode=new&from=depart');">	</input>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');"></input>
</form>
</center>
<script type="text/javascript">
document.form0.num.focus();
</script>

</body>
</html>
<!--#include file="../common/kill.asp"-->