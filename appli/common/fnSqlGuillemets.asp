<%
' Replace les simples guillemets en double.
' @auteur Julien Lab
' Dernière modif 24/11/2004

FUNCTION fnSqlGuillemets (strInput)
	
	Dim strTmp
	If Not strInput = "" Then
		strTmp = Replace(strInput,"'","''")
	End If

	fnSqlGuillemets = strTmp
	
END FUNCTION
%>