<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Sélection des diplômes à imprimer
'
'******************************************
%>


<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


Dim rsDiplome
set rsDiplome = Server.CreateObject("ADODB.recordset")

Dim intNumcyc
if request.querystring("numcyc")>0 then
	intNumcyc=request.querystring("numcyc")
else
	intNumcyc=0
end if
	
Dim intNumcourse,strSQL
intNumcourse=NumCourse()

'On cherche si le numéro de coureur demandé existe
if request.querystring("search")>0 then
	Dim intChercher
	intChercher=request.querystring("search")
	strSQL="SELECT NUMCYC FROM CYCLISTE WHERE NUMCYC=" & intChercher
	rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
	if rsDiplome.EOF then
		Session("strError")="Le cycliste recherché n'existe pas!"
		response.redirect "saisie_depart.asp"
	else
		intNumcyc=intChercher
	end if
	rsDiplome.close
end if

%>


<html>
<% call menu_head %>


<script type="text/javascript">

function chercher_cycliste(num) { 
	if (num!="")
	{
  	var url='diplomes.asp?search=' + num; 
		window.location.replace(url);
	}
} 


function change_cycliste()
{
	var url='diplomes.asp?numCyc=' + document.form1.numcyc.value; 
	window.location.replace(url);
}

function printPDF()
{
	var buf="./action_diplomesPDF.php?numcyc=";
	buf+=document.getElementById("numcyc").value;
	buf+="&mode=unique";
	alert(buf);
	window.location.replace(buf);
}

</script>


<script type="text/javascript">
function load()
{
	form1.num.focus();
}
</script>

</head>
<body>
<% 
call header
call menu %>
<div id="wrapper">
<center>

<h1>IMPRESSION DES DIPLOMES</h1>


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



<form name="form1" action="../common/print.php" method="get" target="_blank">
<table border="0">
	<tr>
		<td align=left><H3>Recherche</H3>
		<b>
		N° de cycliste:&nbsp;
		<input type="text" id="num" name="num" size="4" maxlength="5">
		<input type="button" value="Ok" onclick="var num=document.forms[0].num.value; chercher_cycliste(num);">
		&nbsp;&nbsp;
		Nom:
		<select id="numcyc" name="numcyc" onchange="change_cycliste()" style="background:#e6e6e6; font: bold">
		<option value="0">- - - - - - - - - - - - - -</option>
		<%
		rsDiplome.Open "Select NOM,PRENOM,CYCLISTE.NUMCYC FROM CYCLISTE,PARTICIPER WHERE CYCLISTE.NUMCYC=PARTICIPER.NUMCYC AND PARTICIPER.HDEPART IS NOT NULL AND PARTICIPER.NUMCOURSE=" & intNumcourse & " ORDER BY CYCLISTE.NOM,CYCLISTE.PRENOM,CYCLISTE.NUMCYC ASC",Conn,adOpenForwardOnly,adLockReadOnly
		Dim intnum
		while not rsDiplome.EOF		
			intnum=rsDiplome("NUMCYC")
			if CInt(intnum)=CInt(intNumcyc) then
				response.write("<option value=" & rsDiplome("NUMCYC") & " selected>" & rsDiplome("NOM") & " - " & rsDiplome("PRENOM") & " - " & rsDiplome("NUMCYC") & "</option>")
			else
				response.write("<option value=" & rsDiplome("NUMCYC") & " >" & rsDiplome("NOM") & " - " & rsDiplome("PRENOM") & " - " & rsDiplome("NUMCYC") & "</option>")	
			end if
		
			rsDiplome.MoveNext	
		Wend
		
		rsDiplome.close
		%>
				
		</select>		

<br><br>
<input type="submit" value="Imprimer le diplôme" />
<input type="button" value="Imprimer le diplôme PDF" onclick="printPDF();" />
<br><br>
<input type="button" value="Imprimer tous les diplômes des cyclistes non rentrés (HTML)" onclick="window.open('action_diplomes_non_rentres.asp');" />

</center>
<br>
<center>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
</form>
</center>
</body>
</html>
<%
set rsDiplome=Nothing 
%>

<!--#include file="../common/kill.asp"-->