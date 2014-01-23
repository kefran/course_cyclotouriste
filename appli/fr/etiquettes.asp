<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Affichage et impression des étiquettes
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin

Dim intNumEtiq
Dim strSQL, strTextEtiq
If request.querystring("NUM")="1" then
	intNumEtiq=1
	strSQL="SELECT ETIQUETTE1 AS ETIQ FROM ETIQUETTE WHERE ID=1"
elseif request.querystring("NUM")="2" then
	intNumEtiq=2	
	strSQL="SELECT ETIQUETTE2 AS ETIQ FROM ETIQUETTE WHERE ID=1"
elseif request.querystring("NUM")="3" then
	intNumEtiq=3	
	strSQL="SELECT ETIQUETTE3 AS ETIQ FROM ETIQUETTE WHERE ID=1"
elseif request.querystring("NUM")="4" then
	intNumEtiq=4
	strSQL="SELECT ETIQUETTE4 AS ETIQ FROM ETIQUETTE WHERE ID=1"
else
	Session("strError")="Paramètre des étiquettes à imprimer incorrect!"
	response.redirect "index_admin.asp"
end if

Dim rsEtiquette
set rsEtiquette = Server.CreateObject("ADODB.recordset")
rsEtiquette.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
strTextEtiq=rsEtiquette("ETIQ")
strTextEtiq=unescape(strTextEtiq)

'Il faut convertir le texte
Dim strText
rsEtiquette.close
strSQL="SELECT * FROM CYCLISTE"

'Variables contenant les champs à remplacer
Dim strNumcyc, strNom, strPrenom, strPolit, strCat, strAscap, strAdr_usi, strUsine, strDate_n, strPartic, strAdresse, strVille, strCod_post, strDernumcourse, strDerancourse, strKm, strNbcourses

rsEtiquette.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly

%>


<html>
<head>
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body onload="window.print();">

<%
Dim strTextOriginal
strTextOriginal=strTextEtiq
while not rsEtiquette.EOF
	strNumcyc=rsEtiquette("NUMCYC")
	strNom=rsEtiquette("NOM")
	strPrenom=rsEtiquette("PRENOM")
	strPolit=rsEtiquette("POLIT")
	strCat=rsEtiquette("CAT")
	strAscap=rsEtiquette("ASCAP")
	strAdr_usi=rsEtiquette("ADR_USI")
	strUsine=rsEtiquette("USINE")
	strDate_n=rsEtiquette("DATE_N")
	strPartic=rsEtiquette("PARTIC")
	strAdresse=rsEtiquette("ADRESSE")
	strVille=rsEtiquette("VILLE")
	strCod_post=rsEtiquette("COD_POST")
	strDernumcourse=rsEtiquette("DERNUMCOURSE")
	strDerancourse=rsEtiquette("DERANCOURSE")
	strKm=rsEtiquette("KM")
	strNbcourses=rsEtiquette("NBCOURSES")
	
	strText=ConvertTextEtiquette(strTextEtiq, strNumcyc, strNom, strPrenom, strPolit, strCat, strAscap, strAdr_usi, strUsine, strDate_n, strPartic, strAdresse, strVille, strCod_post, strDernumcourse, strDerancourse, strKm, strNbcourses)
	response.write(strText)
	strTextEtiq=strTextOriginal
	
	rsEtiquette.moveNext
wend
%>

</body>
</html>
<%
rsEtiquette.Close
set rsEtiquette=Nothing 
%>

<!--#include file="../common/kill.asp"-->