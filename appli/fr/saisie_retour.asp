<!--#include file="../common/init.asp"-->

<%


'Accès uniquement aux admins
call TestAdmin

Dim intnum
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
	response.redirect "saisie_retour.asp"
end if

if request.querystring("search")>0 then
	Dim rsSearch
	set rsSearch = Server.CreateObject("ADODB.recordset")
	rsSearch.Open "Select NUMCYC from CYCLISTE WHERE NUMCYC=" & request.querystring("search"),Conn,adOpenForwardOnly,adLockReadOnly
	if rsSearch.EOF then
		Session("strError")="Le cycliste recherché n'existe pas"
		response.redirect "saisie_retour.asp"
	else
		intNumcyc=request.querystring("search")
		'si ajax demande un cycliste on répond directement
		

		if request.querystring("ajax")>0 then 
		
			rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
			
			response.write(rsCyc("ADRESSE")&"|"&rsCyc("ADR_USI")&"|"&rsCyc("ASCAP")&"|"&rsCyc("CAT")&"|"&rsCyc("COD_POST"))
			response.write("|"&rsCyc("DATE_N")&"|"&rsCyc("DEPART")&"|"&rsCyc("NBCOURSES")&"|"&rsCyc("NOM")&"|"&rsCyc("NUMCYC"))
			response.write("|"&rsCyc("EMAIL")&"|"&rsCyc("POLIT")&"|"&rsCyc("PRENOM")&"|"&rsCyc("SEXE")&"|"&rsCyc("USINE"))
			response.write("|"&rsCyc("VILLE"))
			rsCyc.Close
			response.end
		
		end if

		
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-15">
<script src="../common/xhr.js" ></script>
<script type="text/javascript">


function getCycliste(el){
var numcyc=el.value;
var xhr = createXHR();
var data="?search="+el.value;

data+="&ajax=1";

		xhr.open('GET','saisie_retour.asp'+data,true);
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
	
	document.form1.c1.checked=false;
	document.form1.c2.checked=false;
	document.form1.c3.checked=false;
	
	document.getElementById("nbcourses").innerHTML=res[7];
	document.getElementById("numcyc").innerHTML=res[9];
	document.getElementById("nom").innerHTML=res[8];
	document.getElementById("prenom").innerHTML=res[12];
	document.getElementById("polit").innerHTML=res[11]+'.';
	document.getElementById("date_n").innerHTML=res[5];
	document.getElementById("adresse").innerHTML=res[0];
	document.getElementById("cod_post").innerHTML=res[4];
	document.getElementById("ville").innerHTML=res[15];

	document.form0.addRetour.disabled=false;
	document.form1.addRetour1.disabled=false;
	
	document.form0.modCyc.disabled=false;
	document.form1.modCyc1.disabled=false;

}


function ajaxSubmit()
{

	var xhr = createXHR();
	var data ="cbnom=";
	data+=document.getElementById('cbnom').value;
	data+="&ajax=1";
			
		xhr.open('POST','action_saisie_retour.asp',true);
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
	
	document.getElementById("nbcourses").innerHTML="";
	document.getElementById("numcyc").innerHTML="";
	document.getElementById("nom").innerHTML="";
	document.getElementById("prenom").innerHTML="";
	document.getElementById("polit").innerHTML="";
	document.getElementById("date_n").innerHTML="";
	document.getElementById("adresse").innerHTML="";
	document.getElementById("cod_post").innerHTML="";
	document.getElementById("ville").innerHTML="";

	document.form0.addRetour.disabled=true;
	document.form1.addRetour1.disabled=true;

	document.form0.modCyc.disabled=true;
	document.form1.modCyc1.disabled=true;
	
	document.form0.num.focus();

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
<div id="wrapper" >
<center>
<H1>SAISIE DES RETOURS</H1>

<b><font color="#ff0000"><div id="message" name="message"></div>

<% =Session("strError") %>

<% Session("strError")="" %>

</font></b>

<form name="form0" action="search_saisie_retour.asp" method="post">

	<input type="button" id="addRetour" value="Enregister le retour" onclick="ajaxSubmit();" disabled ></input>


	<input type="button" id="modCyc" value="Modifier le cycliste" onclick="window.location.replace(((document.form0.cbnom.value!=0)?('edit_cycliste.asp?from=depart&mode=edit&numedit='+document.form0.cbnom.value):'saisie_depart.asp'));" ></input>

<input type="button" value="Ajouter un cycliste" onclick="window.location.replace('edit_cycliste.asp?mode=new&from=depart');">	</input>


<input class="btn btn-primary" type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');"></input>

<table border="0">
	<tr>
		<td align=left><H3>Recherche</H3>
		<b>
		N° de cycliste:&nbsp;
		<input type="text" name="num" id="num" size="4" maxlength="5"></input>
		<input type="submit" value="Ok" onclick="getCycliste(document.getElementById('num'));"></input>
		&nbsp;&nbsp;
		Nom:
			<select name="cbnom" id="cbnom" onchange="getCycliste(this);" style="background:#e6e6e6; font: bold">
		<option value="0">- - - - - - - - - - - - - -</option>
		<%
		
			rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC IN (SELECT NUMCYC FROM PARTICIPER WHERE NUMCOURSE=" & intNumcourse & " AND HDEPART IS NOT NULL AND HARRIVEE IS NULL) ORDER BY NOM,PRENOM,NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		
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
		<form name="form1" action="action_saisie_retour.asp" method="post">
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
		
		<%
		rsCyc.close
		rsCyc.Open "Select * from CYCLISTE WHERE NUMCYC=" & intNumcyc,Conn,adOpenForwardOnly,adLockReadOnly
		%> 

		<br>
		
		</b>

		&nbsp;&nbsp;&nbsp;&nbsp;
		Participations:
	
		<div style="display:inline;" id="nbcourses" name="nbcourses">
			<%
				if not rsCyc.EOF then 
					response.write(rsCyc("NBCOURSES")) 
				end if
			%>
		</div>
		
		<div id='identiteCyc' >
		<H3>Identité</H3>
		N° cycliste:
		<div style="display:inline;" id="numcyc" name="numcyc">

		<% if not rsCyc.EOF then 
		response.write(rsCyc("NUMCYC")) 
		end if%>
	</div>	

	
		<div id="polit" name="polit">
				
				<% if not rsCyc.EOF then 
			response.write(rsCyc("POLIT")) 
			end if%>
		</div>
	
		<div name="nom" id="nom">
		
	
		<% 
			if not rsCyc.EOF then 
				response.write(rsCyc("NOM")&" ") 
			end if%>
			</div>

			<div name="prenom" id="prenom">
	
		<% 
			if not rsCyc.EOF then 
				response.write(rsCyc("PRENOM")) 
			end if
		%>
		</div>
		</div>
	
		Date de naissance:
		<div style='display:inline;'id="date_n" name="date_n">
			
		<% if not rsCyc.EOF then 
		response.write(rsCyc("DATE_N")) 
		end if%>
	
		</div>
				
		<br><br>

		<div id="adresse" name="adresse" style="display:inline;">
		<% if not rsCyc.EOF then 
		response.write(rsCyc("ADRESSE")) 
		end if%>
		</div>
	
		&nbsp;&nbsp;
		<br>
		Code postal:

		<div id="cod_post" name="code_post" style="display:inline;">
		<% if not rsCyc.EOF then 
		response.write(rsCyc("COD_POST")) 
		end if%>
		</div>

		&nbsp;&nbsp;
		Ville:
		<div id="ville" name="ville" style="display:inline;">
		
			<% if not rsCyc.EOF then 
			response.write(rsCyc("VILLE")) 
			end if%>
		</div>
		
		
		&nbsp;&nbsp;
		<br>
	
		&nbsp;&nbsp;
		</td>

	</tr>
</table>



	<input type="button" id="addRetour1" value="Enregister le retour" onclick="ajaxSubmit();" disabled></input>


		<input type="button" id="modCyc1" value="Modifier le cycliste" onclick="window.location.replace(((document.form0.cbnom.value!=0)?('edit_cycliste.asp?from=depart&mode=edit&numedit='+document.form0.cbnom.value):'saisie_depart.asp'));"></input> 

<input type="button" id="addCycliste" value="Ajouter un cycliste" onclick="window.location.replace('edit_cycliste.asp?mode=new&from=depart');">	</input>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');"></input>
</form>
</center>
<script type="text/javascript">
document.form0.num.focus();
</script>
</div>
</body>
</html>
<!--#include file="../common/kill.asp"-->
