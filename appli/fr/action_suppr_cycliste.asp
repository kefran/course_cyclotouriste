<!--#include file="../Common/init.asp" -->

<%
' Permet de supprimer un cycliste
' @auteur Julien Lab
' Derni�re modif 24/11/2004
Dim rsDelete, strError, intError

' V�rification du mot de passe admin pour supprimer le cycliste
if Request("password")<>Application("stradmin_pass") then
	Session("strError")="Mauvais mot de passe!"
	response.redirect "index_admin.asp"		
end if	

' Test du num�ro du cycliste qui doit �tre supprim�
If IsNumeric(Request("numsupp")) Then

	' Suppression dans la table PARTICIPER
	Conn.Execute ("DELETE FROM PARTICIPER Where Numcyc = " & CInt(Request("numsupp"))),intError,adcmdtext

	Conn.BeginTrans
	Conn.CommandTimeOut=120
	' Suppression dans la table Cycliste
	Conn.Execute ("DELETE FROM Cycliste WHERE Numcyc = " & CInt(Request("numsupp"))),intError,adcmdtext
	
	' V�rification d'une erreur pendant la suppression	
	If intError <> 1 Then
		Conn.RollbackTrans
		Session("strError")="Erreur lors de la suppression du cycliste"
		Response.Redirect("index_admin.asp")
	Else
		Conn.CommitTrans
		Session("strError")="Le cycliste a bien �t� supprim�"
		Response.Redirect("index_admin.asp")
	End If

End If

%>
<!--#include file="../Common/kill.asp" -->