<%
Public Function ConvertTextDiplome(strText, strNom,strPrenom,strPolit,strAnneecourse,strDatecourse,strDistance,intNumcircuit,strNbcourses)
	strText=replace(strText,"[gras]","<b>")
	strText=replace(strText,"[/gras]","</b>")
	strText=replace(strText,"[italique]","<i>")
	strText=replace(strText,"[italique]","</i>")
	strText=replace(strText,"[titre]","<h1>")
	strText=replace(strText,"[/titre]","</h1>")
	strText=replace(strText,"[retour_ligne]","<br>")
	
	if isNull(strPolit) then
		strText=replace(strText,"[politesse]"," ")
	else
		strText=replace(strText,"[politesse]",strPolit)
	end if
	
	if isNull(strNom) then
		strText=replace(strText,"[nom]"," ")
	else
		strText=replace(strText,"[nom]",strNom)
	end if
	
	if isNull(strPrenom) then
		strText=replace(strText,"[prenom]"," ")
	else
		strText=replace(strText,"[prenom]",strPrenom)
	end if
	
	if isNull(strAnneecourse) then
		strText=replace(strText,"[annee]"," ")
	else
		strText=replace(strText,"[annee]",strAnneecourse)
	end if
	
	if isNull(strDatecourse) then
		strText=replace(strText,"[date]"," ")
	else
		strText=replace(strText,"[date]",strDatecourse)
	end if
	
	if isNull(intNumcircuit) then
		strText=replace(strText,"[numcircuit]"," ")
	else
		strText=replace(strText,"[numcircuit]",intNumcircuit)
	end if
	
	if isNull(strDistance) then
		strText=replace(strText,"[distance]"," ")
	else
		strText=replace(strText,"[distance]",strDistance)
	end if
	
	if isNull(strNbcourses) then
		strText=replace(strText,"[nbcourses]"," ")
	else
		strText=replace(strText,"[nbcourses]",strNbcourses)
	end if
	
	
	
	ConvertTextDiplome=strText

End Function
%>