<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Recherche d’un cycliste par son n°
'
'******************************************
%>

<!--#include file="../common/init.asp"-->


<%
'Accès uniquement aux admins
call TestAdmin

dim strURL
strURL="saisie_depart.asp?search=" & request.form("NUM")
response.redirect strURL

%>


<!--#include file="../common/kill.asp"-->