
<%
Public Function ConvertTextEtiquette(strText,strNumcyc, strNom, strPrenom, strPolit, strCat, strAscap, strAdr_usi, strUsine, strDate_n, strPartic, strAdresse, strVille, strCod_post, strDernumcourse, strDerancourse, strKm, strNbcourses)
	strText=replace(strText,"[gras]","<b>")
	strText=replace(strText,"[/gras]","</b>")
	strText=replace(strText,"[italique]","<i>")
	strText=replace(strText,"[italique]","</i>")
	strText=replace(strText,"[titre]","<h1>")
	strText=replace(strText,"[/titre]","</h1>")
	strText=replace(strText,"[retour_ligne]","<br>")
	strText=replace(strText,"[espace]","&nbsp;")
	strText=replace(strText,"[tabulation]","&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
	
	
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
	
	if isNull(strAdresse) then
		strText=replace(strText,"[adresse]"," ")
	else
		strText=replace(strText,"[adresse]",strAdresse)
	end if
	
	if isNull(strVille) then
		strText=replace(strText,"[ville]"," ")
	else
		strText=replace(strText,"[ville]",strVille)
	end if
	
	if isNull(strCod_post) then
		strText=replace(strText,"[code_postal]"," ")
	else
		strText=replace(strText,"[code_postal]",strCod_post)
	end if
	
	if isNull(strNumcyc) then
		strText=replace(strText,"[numcyc]"," ")
	else
		strText=replace(strText,"[numcyc]",strNumcyc)
	end if
	
	if isNull(strDate_n) then
		strText=replace(strText,"[date_naissance]"," ")
	else
		strText=replace(strText,"[date_naissance]",strDate_n)
	end if
	
	if isNull(strPartic) then
		strText=replace(strText,"[partic]"," ")
	else
		strText=replace(strText,"[partic]",strPartic)
	end if
	
	if isNull(strDernumcourse) then
		strText=replace(strText,"[der_num_course]"," ")
	else
		strText=replace(strText,"[der_num_course]",strDernumcourse)
	end if
	
	if isNull(strDerancourse) then
		strText=replace(strText,"[der_annee_course]"," ")
	else
		strText=replace(strText,"[der_annee_course]",strDerancourse)
	end if
	
	if isNull(strKm) then
		strText=replace(strText,"[km]"," ")
	else
		strText=replace(strText,"[km]",strKm)
	end if
	
	if isNull(strNbcourses) then
		strText=replace(strText,"[nb_courses]"," ")
	else
		strText=replace(strText,"[nb_courses]",strNbcourses)
	end if
	
	if isNull(strCat) then
		strText=replace(strText,"[categorie]"," ")
	else
		strText=replace(strText,"[categorie]",strCat)
	end if
	
	if isNull(strAscap) then
		strText=replace(strText,"[ascap]"," ")
	else
		strText=replace(strText,"[ascap]",strAscap)
	end if
	
	if isNull(strAdr_usi) then
		strText=replace(strText,"[adrusine]"," ")
	else
		strText=replace(strText,"[adrusine]",strAdr_usi)
	end if
	
	if isNull(strUsine) then
		strText=replace(strText,"[usine]"," ")
	else
		strText=replace(strText,"[usine]",strUsine)
	end if
	
	
	ConvertTextEtiquette=strText

End Function
%>