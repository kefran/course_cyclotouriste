<!--#include file="../common/init.asp"-->
<%
' Affichage de la liste des cyclistes complète ou issue d'une recherche
' @auteur Julien Lab
' Dernière modif 24/11/2004

'Accès uniquement aux admins
call TestAdmin

Dim strColor, Nmax, Ndeb, Lettre, strWhere, strOrder, Lien, Lien2, strSql, rsCycliste2, rsCycliste, Ntotal, i, strLigne
Dim Npag, Npag2, tmp, blnVide, Ncur

blnVide = false
%>
<HTML>
<head>
<% call menu_head %>


<script type="text/javascript">
function supprimer_cycliste(numcyc)
{
	if (confirm('Etes-vous sur de vouloir supprimer la cycliste numéro '+ numcyc + '?')==true){
	var url='suppr_cycliste.asp?numsupp=' + numcyc; 
	window.location.replace(url);
	}
}
</script>
<link href="../style.css" rel="stylesheet" type="text/css" />
<link type="text/css" href="../bootstrap/css/bootstrap.css"  />
</head>
<BODY>
<% 
call header
call menu %>
<center>
<div id="wrapper">
<%
'Dim Nmax, Ndeb, Lettre, strWhere, Lien, i

strColor = "#DDEAEE"


Nmax = 18 ' nombre par page
' 1ère fiche transmise par l'URL
Ndeb = Cint(request.queryString("num"))
' Votre autre paramètre
Lettre = request.queryString("lettre")


' Si on veut une recherche sur le nom
If Request("nom") <> "" Then
	If Application("blnBDDOracle") = true Then
		strWhere = " Where upper(nom) LIKE '%" & UCase(fnsqlguillemets(Request("nom"))) & "%' "
	Else
		strWhere = " Where nom LIKE '%" & fnsqlguillemets(Request("nom")) & "%' "
	End If
' Si on désire afficher par index
Else
	If Application("blnBDDOracle") = true Then
		strWhere = " WHERE upper(nom) like '" & Lettre & "%' "
	Else
		strWhere = " WHERE nom like '" & Lettre & "%' "
	End If
End If

' Si on veut une recherche sur le prénom
If Request("prenom") <> "" Then
	If Application("blnBDDOracle") = true Then
		strWhere = strWhere & "AND upper(prenom) LIKE '%" & UCase(fnsqlguillemets(Request("prenom"))) & "%' "
	Else
		strWhere = strWhere & "AND prenom LIKE '%" & fnsqlguillemets(Request("prenom")) & "%' "
	End If
End If

' Si on veut une recherche sur la ville
If Request("ville") <> "" Then
	If Application("blnBDDOracle") = true Then
		strWhere = strWhere & "AND upper(ville) LIKE '%" & UCase(fnsqlguillemets(Request("ville"))) & "%' "
	Else
		strWhere = strWhere & "AND ville LIKE '%" & fnsqlguillemets(Request("ville")) & "%' "
	End If
End If

' Différents critères de tri
if Request.querystring("tri")="num_asc" then
	strOrder=strOrder & "ORDER BY NUMCYC ASC"
end if

if Request.querystring("tri")="num_desc" then
	strOrder=strOrder & "ORDER BY NUMCYC DESC"
end if

if Request.querystring("tri")="nom_asc"  or Request.querystring("tri")="" then
	strOrder=strOrder & "ORDER BY NOM ASC"
end if

if Request.querystring("tri")="nom_desc" then
	strOrder=strOrder & "ORDER BY NOM DESC"
end if

if Request.querystring("tri")="prenom_asc" then
	strOrder=strOrder & "ORDER BY PRENOM ASC"
end if

if Request.querystring("tri")="prenom_desc" then
	strOrder=strOrder & "ORDER BY PRENOM DESC"
end if

if Request.querystring("tri")="sexe_asc" then
	strOrder=strOrder & "ORDER BY SEXE ASC"
end if

if Request.querystring("tri")="sexe_desc" then
	strOrder=strOrder & "ORDER BY SEXE DESC"
end if


' Le lien correspondant
Lien = "&lettre=" & Lettre & "&tri=" & Request("tri") & "&nom=" & Request("nom") & "&prenom=" & Request("prenom") & "&ville=" & Request("ville")
Lien2 = "&lettre=" & Lettre & "&nom=" & Request("nom") & "&prenom=" & Request("prenom") & "&ville=" & Request("ville")
%>

<%' nombre total de fiches
strSql="SELECT count(*) FROM cycliste " & strWhere
rsCycliste2 = conn.execute(strSql)
Ntotal = CInt(rsCycliste2(0))-1 ' commence à 0

' sélectionne les fiches de la table
Set rsCycliste = server.createobject("ADODB.Recordset")
If Application("blnBDDOracle") Then
	strSql="SELECT * " &_
	"FROM (Select * From Cycliste "&strWhere & " " & strOrder & ")" &_
	" Where rownum <= " & (Ndeb+Nmax)
Else
	strSql="SELECT TOP " & (Ndeb+Nmax)_
	& " * FROM cycliste"&strWhere& strOrder
End If
rsCycliste.Open strSql,Conn , 3, 3
%>
<% If Request("nom") <> "" OR Request("prenom") <> "" OR Request("ville") <> "" OR Request("lettre") <> "" Then %>
<H1>Résultat de la recherche</H1>
<% Else %>
<H1>Liste des cyclistes</H1>
<% End If %>
<% If Request("nom") = "" AND Request("prenom") = "" AND Request("ville") = "" Then %>
<p align=center><a href="liste_cycliste.asp" >Tout afficher</a>
&nbsp;<%
for i = asc("A") to asc("Z")
   response.write "<A href='?lettre=" & chr(i) & "'>"_
      & chr(i) & "</A> "
next%></p>
<% End If

If NOT rsCycliste.EOF Then
%>

<table width="99%" class="table" border="0">
<tr>
<td width="3%"></td>
<!-- <td width="3%"></td> -->
<% If Request("nom") <> "" OR Request("prenom") <> "" OR Request("ville") <> "" OR Request("lettre") <> "" Then %>
<td width="10%" align="center" bgcolor="#CCD1E0"><b>Numéro&nbsp;<a href="liste_cycliste.asp?tri=num_asc<%=Lien2%>"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=num_desc<%=Lien2%>"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="15%" align="center" bgcolor="#CCD1E0"><b>Nom&nbsp;<a href="liste_cycliste.asp?tri=nom_asc<%=Lien2%>"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=nom_desc<%=Lien2%>"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="15%" align="center" bgcolor="#CCD1E0"><b>Pr&eacute;nom&nbsp;<a href="liste_cycliste.asp?tri=prenom_asc<%=Lien2%>"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=prenom_desc<%=Lien2%>"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="7%" align="center" bgcolor="#CCD1E0"><b>Sexe&nbsp;<a href="liste_cycliste.asp?tri=sexe_asc<%=Lien2%>"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=sexe_desc<%=Lien2%>"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<% Else %>
<td width="10%" align="center" bgcolor="#CCD1E0"><b>Numéro&nbsp;<a href="liste_cycliste.asp?tri=num_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=num_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="15%" align="center" bgcolor="#CCD1E0"><b>Nom&nbsp;<a href="liste_cycliste.asp?tri=nom_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=nom_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="15%" align="center" bgcolor="#CCD1E0"><b>Pr&eacute;nom&nbsp;<a href="liste_cycliste.asp?tri=prenom_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=prenom_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<td width="7%" align="center" bgcolor="#CCD1E0"><b>Sexe&nbsp;<a href="liste_cycliste.asp?tri=sexe_asc"><img src="../common/images/haut.png" border="0" alt="croissant"></a>&nbsp;<a href="liste_cycliste.asp?tri=sexe_desc"><img src="../common/images/bas.png" border="0" alt="décroissant"></a></b></td>
<% End If %>
<td width="30%" align="center" bgcolor="#CCD1E0"><b>Adresse&nbsp;</b></td>
<td width="20%" align="center" bgcolor="#CCD1E0"><b>Ville&nbsp;</b></td>
<td width="20%" align="center" bgcolor="#CCD1E0"><b>Nb de participations</b></td>
</tr>
<%
	' Avance à la 1ère
	rsCycliste.Move(Ndeb)

' tant qu'il reste des fiches
while not rsCycliste.eof
   ' affiche le champ
	If Ncur <> Nmax Then
	If strColor = "#FBFBFB" Then strColor = "#DDEAEE" Else strColor = "#FBFBFB"

	response.write("<tr>")	
	strLigne="<td width=20 bgcolor=" & strColor & " align=center><a href=edit_cycliste.asp?mode=edit&numedit=" & rsCycliste("NUMCYC") & "><img src=../common/images/modif.png border=0  alt=Modifier le cycliste></a></td>"
	response.write(strLigne)
'	strLigne="<td width=20 bgcolor=" & strColor & " align=center><a href=# onclick=supprimer_cycliste(" & rsCycliste("NUMCYC") & ")><img src=../common/images/supprimer.png border=0  alt=Supprimer le cycliste></a></td>"
'	response.write(strLigne)
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("NUMCYC") & "</td>")
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("NOM") & "</td>")
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("PRENOM") & "</td>")
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("SEXE") & "</td>")
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("ADRESSE") & "</td>")
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("VILLE") & "</td>")
	response.write("<td align=center bgcolor=" & strColor & ">" & rsCycliste("NBCOURSES") & "</td>")
	response.write("</tr>")
	Ncur = Ncur + 1
	End If
   ' fiche suivante
   rsCycliste.MOVENEXT
wend %>
</table>
<%Else
blnVide = true
%>
<br>Aucun résultat n'a été trouvé
<%
End If
%>

<% If NOT blnVide Then %>
<table cellpadding=3><tr>
<% ' NAVIGATION
' Des fiches avant ?
if Ndeb > 0 then%>
   <td>
      <A href="?num=<%=Ndeb - Nmax%><%=Lien%>"
      >Retour</A>
   </td>
<%end if%>
   <td>
<% ' Page courante
Npag = int(Ndeb/Nmax)+1 : Npag2 = Npag-1
tmp = "<b>" & Npag & "</b>"
' Max 9 pages avant
while Npag2>0 AND Npag2>Npag-6
   tmp = "<A href='?num=" & ((Npag2-1)*Nmax)_
      & Lien & "'>" & Npag2 & "</A> " & tmp
   Npag2 = Npag2-1
wend
' Max 9 pages après
Npag2 = Npag
while Npag2*Nmax<=Ntotal AND Npag2<Npag+5
   Npag2 = Npag2+1
   tmp = tmp & " <A href='?num=" & ((Npag2-1)*Nmax)_
      & Lien & "'>" & Npag2 & "</A>"
wend
response.write tmp
%>
   </td>
<% ' Des fiches après ?
if Ntotal>Ndeb+Nmax then%>
   <td>
      <A href="?num=<%=Ndeb+Nmax%><%=Lien%>"
      >Suite</A>
   </td>
<%end if
End If

rsCycliste.close : set rsCycliste=nothing%>
</tr></table>

<br>
<input type="button" value="Imprimer" onclick="window.print();">
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
</div>
</center>
</BODY></HTML>
<!--#include file="../common/kill.asp"-->