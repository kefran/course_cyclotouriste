<!--#include file="../Common/init.asp" -->
<!--#include file="../Common/MD5.asp" -->

<%
' Permet de modifier le mot de passe d'un utilisateur pour un base oracle
' @auteur Julien Lab
' Dernière modif 24/11/2004

' Test la Session de l'utilisateur
If (Session("intUser") <> CInt(Request("num"))) Then
	call TestAdmin
End If

' Vérification que les 2 mots de passes correspondent
If Request("mdp") <> Request("remdp") Then
	Session("strError") = "Les deux mots de passes saisis ne correspondent pas"
	Response.Redirect("./modif_password.asp?numcyc=" & Request("num"))
End If

' Update de la base
Conn.Execute ("UPDATE Cycliste Set password = '" & MD5(Ucase(Request("mdp"))) & "' Where numcyc = " & Request("num"))

' Redirection
If (Session("intUser") <> CInt(Request("num"))) Then
	Response.Redirect("./liste_cycliste.asp")
Else
	Response.Redirect("./edit_cycliste.asp?mode=edit&numedit=" & Request("num"))
End If

%>
<!--#include file="../Common/kill.asp" -->