<%
' Fonction retournant le numéro max du cycliste
' @auteur Julien Lab
' Dernière modif 24/11/2004

Public Function NumCoureur()
	Dim intNum, rsNumCycliste, strSql

	Set rsNumCycliste = Conn.Execute ("SELECT Max(Numcyc) FROM Cycliste")

	If IsNull(rsNumCycliste(0)) OR IsEmpty(rsNumCycliste(0)) OR rsNumCycliste(0) = "" Then
		intNum = 0
	Else
		intNum = rsNumCycliste(0)
	End If

	rsNumCycliste.close
	Set rsNumCycliste = nothing

	NumCoureur = intNum
End Function
%>