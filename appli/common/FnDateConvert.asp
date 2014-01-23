<%
Public Function DateConvert(strDate)	
	
if Application("blnBDDOracle")=true then
	dim intPos
	intPos=InStr(strDate," ")
	if isNull(strDate) then
		dateConvert=strDate
	else
		strDate=Mid(strDate,intPos+1)
		DateConvert=strDate			
	end if
else
	DateConvert=strDate
end if

End Function
%>