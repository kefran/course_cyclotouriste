<%
Dim Conn
If Not isObject(Conn) Then
	Set Conn = Server.CreateObject("ADODB.Connection")
end if

Conn.ConnectionString = Application("strConnexion")


If Conn.State = adStateClosed Then
	Conn.Open
end if
%>