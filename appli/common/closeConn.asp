<%
If Conn.State = 1 Then
	Conn.Close
	Set Conn = Nothing
End If
%>