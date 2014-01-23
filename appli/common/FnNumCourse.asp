<%
Public Function NumCourse()
	Dim intNum, rsNumCourse, strSql

	Set rsNumCourse = Conn.Execute ("SELECT Max(numcourse) FROM COURSE")

	If IsNull(rsNumCourse(0)) OR IsEmpty(rsNumCourse(0)) OR rsNumCourse(0) = "" Then
		intNum = 0
	Else
		intNum = rsNumCourse(0)
	End If

	rsNumCourse.close
	Set rsNumCourse = nothing

	NumCourse = intNum
End Function
%>