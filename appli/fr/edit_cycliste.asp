<!--#include file="../Common/init.asp" -->
<!--#include file="../Common/MD5.asp" -->
<%
' Edition ou ajout d'un cycliste
' @auteur Julien Lab
' Dernière modif 24/11/2004

Dim strNom, strPrenom, strSexe, strAdresse, strVille, intCp, strLogin, strMdp, strReMdp, intIdCycliste, rsCycliste, intNumcyc
Dim rsCyclisteUpdate, intNum, strError,  strPolit, strAdUsine, rsCourse, strUsine, strASCAP, strCat, strSql, intNumCircuit, intNumcourse
Dim strDate, intNumCircuitOld, intError, blnPb, rsCategorie, rsPolitesse, rsLogin, rsNbCourses, strPartic, strOldError, strTestPartic
Dim cpt, blnTest, intNbCourses, intDerCourse, inttmp

' intialisation des variables définies
strNom = ""
strPrenom = ""
strSexe = ""
strAdresse = ""
strVille = ""
strUsine = ""
strAdUsine = ""
strASCAP = ""
strPolit = ""
strCat = ""
strDate = ""
intCp = ""
strLogin = ""
strMdp = ""
strReMdp = ""
strSql = ""
intNumCircuit = 0
intNumCourse = ""
intNumCircuitOld = 0
strError = ""
intError = 0
strPartic = ""
blnTest = false
intNbCourses = 0
intDerCourse = NULL

' Sauvegarde de la précédente erreur
strOldError = Session("strError")

' Vérification des champs entrées
' Vérification si le nom a été saisi
If (Request("nom") = "") Then strError = "Votre nom est obligatoire pour vous enregistrer, veuillez recommencer SVP.<br>"
' Le nom ne doit pas contenir de chiffres
If IsNumeric(Request("nom")) Then strError = strError & "Votre nom doit être en lettre et non en chiffre pour vous enregistrer, veuillez recommencer SVP.<br>"
' Vérification si le prénom a été saisi
If (Request("prenom") = "") Then strError = strError & "Votre prénom est obligatoire pour vous enregistrer, veuillez recommencer SVP.<br>"
' Le prénom ne doit pas contenir de chiffres
If IsNumeric(Request("prenom")) Then strError = strError & "Votre prénom doit être en lettre et non en chiffre pour vous enregistrer, veuillez recommencer SVP.<br>"			
' Test si le code postale est un nombre <=5
If (Request("cp") <> "" AND (NOT IsNumeric(Request("cp")) OR CInt(Len(request("cp")))>5)) Then strError = strError & "Le code postal doit être un nombre à 5 chiffres.<br>"
' Test si la ville ne contient pas de chiffres
If (Request("ville") <> "" AND IsNumeric(Request("ville"))) Then strError = strError & "Une ville doit être en lettre.<br>"
' Test si le nom de l'usine ne contient pas de chiffres
If (Request("usine") <> "" AND IsNumeric(Request("usine"))) Then strError = strError & "Le code USINE doit être en lettre.<br>"
' Test si la catégorie ne contient pas de chiffres et ne contient pas plus de 3 caractères
If (Request("cat") <> "" AND IsNumeric(Request("cat")) AND CInt(Len(request("cp")))>3) Then strError = strError & "Le code catégorie doit être en lettre et inférieure ou égale à 3.<br>"
' Vérifie la forme de la date
If (Request("date") <> "" AND NOT IsDate(Request("date"))) Then strError = strError & "La date doit être de la forme jj/mm/aaaa.<br>"
' Vérifie la saisie du mot de passe et du login
If (Request("login") = "" AND Request("mdp") <> "") Then strError = strError & "Si vous avez un mot de passe, il faut saisir également un login.<br>"

' Vérifie, si c'est la base Oracle, que le login est bien saisi
If (Request("login") <> "" AND Application("blnBDDOracle")) Then
	Set rsLogin = Conn.Execute("Select login, numcyc from Cycliste Where numcyc <> " & Request("numcyc") & " AND upper(LOGIN) = '" & Ucase(Request("login")) & "'")
	If (NOT rsLogin.EOF) Then
		strError = strError & "Le login que vous proposez est déjà utilisé.<br>"
	End If
End If

 
If Request("partic") <> "" Then
	' Récupération du champ PARTIC, NBCOURSES et DEARNCOURSE dans la table cycliste
	Set rsCycliste = Conn.Execute ("SELECT PARTIC, NBCOURSES, DERANCOURSE FROM Cycliste WHERE Numcyc = " & CInt(Request("numcyc")))
	
	' Vérification du champ PARTIC saisi et celui de la base
	' Si il est différent vérfication de sa bonne construction
	If rsCycliste("PARTIC") <> Request("partic") Then
		Set rsNbCourses = Conn.Execute("Select count(*) as nb from course")
		If Len(Request("partic")) = rsNbCourses("nb") AND IsNumeric(Request("partic")) Then
			cpt = 1
			While cpt <= rsNbCourses("nb")
				If ((CInt(Mid(Request("partic"),cpt,1)) <> 0) AND (CInt(Mid(Request("partic"),cpt,1)) <> 1)) Then
					blnTest = true
				ElseIf (CInt(Mid(Request("partic"),cpt,1)) = 1) Then
						intNbCourses = intNbCourses + 1
						inttmp = cpt
				End If
				cpt = cpt + 1
			Wend
			If blnTest Then
				strError = strError & "Le champ Partic doit être composé de 0 ou de 1.<br>"
			Else
				Set rsCourse = Conn.Execute("SELECT AnneeCourse FROM COURSE ORDER BY AnneeCourse")
				cpt = 1
				While cpt < inttmp AND NOT rsCourse.EOF
					cpt = cpt + 1
					rsCourse.MoveNext
				Wend
				intDerCourse = rsCourse("AnneeCourse")
				Set rsCourse = nothing
			
			End If
		Else
			strError = strError & "Le champ Partic n'est pas conforme aux exigences : le nombre de chiffres doit être égale au nombre de courses.<br>"
		End If
		Set rsNbCourses = nothing
	Else
		intNbCourses = rsCycliste("NBCOURSES")
		intDerCourse = rsCycliste("DERANCOURSE")	
	End If

	Set rsCycliste = nothing

End If

' Si il n'y a pas d'erreurs dans la saisie on peut commener le traitement
If strError = "" Then

	' Initialisation des variables avec ce qui a été saisi
	strPolit = Left(Request.Form("polit"),3)
	strNom = Left(fnSqlGuillemets(Request.Form("nom")),25)
	strPrenom = Left(fnSqlGuillemets(Request.Form("prenom")),20)
	strSexe = Left(Request.Form("sexe"),1)
	strAdresse = Left(fnSqlGuillemets(Request.Form("adresse")),35)
	strVille = Left(fnSqlGuillemets(Request.Form("ville")),35)
	strUsine = Left(Request.Form("usine"),4)
	strAdUsine = Left(Request.Form("AdUsine"),20)
	strASCAP = Left(Request.Form("ascap"),7)
	strDate = Request.Form("date")
	strCat = Left(Request.Form("cat"),3)
	intCp = Request.Form("cp")
	strLogin = Request.Form("login")
	strMdp = Request.Form("mdp")
	strReMdp = Request.Form("remdp")
	strPartic = Request.Form("partic")
	If Request.Form("distance") <> "" Then
		intNumCircuit = Request.Form("distance")
	End If
	intNumCourse = Request.Form("numcourse")
	intNumCircuitOld = Request.Form("numcircuitold")
	
	' Si on est dans le mode édition 
	If Request("mode") = "edit" Then
		
		' Test la session de l'utilisateur
		If Session("intUser") <> CInt(Request("numcyc")) Then
			call TestAdmin
		End If
		
		'strDate = replace(strDate,"/","-")
		'If NOT Application("blnBDDOracle") Then
		'	strDate = "#" & strDate & "#"
		'End If
		
		' Mise à jour du cycliste suivant différent cas de figures
		If (Request.Form("login") = "") Then
			Conn.BeginTrans
			Conn.CommandTimeOut=120
			If Application("blnBDDOracle") Then
				Conn.Execute ("UPDATE Cycliste " &_
								"Set Nom = '" & strNom & "', Prenom = '" & strPrenom & "', sexe = '" & strSexe &_
								"', Adresse = '" & strAdresse & "', Ville = '" & strVille & "', Cod_post = '" & intCp & "' " &_
								", login = '" & UCase(strNom) & "', Polit = '" & strPolit & "', Adr_usi = '" & strAdUsine & "', usine = '" & strUsine & "' " &_
								", ASCAP = '" & strASCAP & "', cat = '" & strCat & "', date_n = '" & strDate & "', partic = '" & strPartic & "' " &_
								", DERANCOURSE = " & intDerCourse & ", NBCOURSES = " & intNbCourses & " " &_
								"Where numcyc = " & CInt(Request("numcyc"))),intError,adcmdtext
			Else
				If strDate = "" Then
					Conn.Execute ("UPDATE Cycliste " &_
								"Set Nom = '" & strNom & "', Prenom = '" & strPrenom & "', sexe = '" & strSexe &_
								"', Adresse = '" & strAdresse & "', Ville = '" & strVille & "', Cod_post = '" & intCp & "' " &_
								", Polit = '" & strPolit & "', Adr_usi = '" & strAdUsine & "', usine = '" & strUsine & "'" &_
								", ASCAP = '" & strASCAP & "', cat = '" & strCat & "', date_n = NULL, partic = '" & strPartic & "' " &_
								", DERANCOURSE = " & intDerCourse & ", NBCOURSES = " & intNbCourses & " " &_
								"Where numcyc = " & CInt(Request("numcyc"))),intError,adcmdtext
			 	Else
					Conn.Execute ("UPDATE Cycliste " &_
								"Set Nom = '" & strNom & "', Prenom = '" & strPrenom & "', sexe = '" & strSexe &_
								"', Adresse = '" & strAdresse & "', Ville = '" & strVille & "', Cod_post = '" & intCp & "' " &_
								", Polit = '" & strPolit & "', Adr_usi = '" & strAdUsine & "', usine = '" & strUsine & "' " &_
								", ASCAP = '" & strASCAP & "', cat = '" & strCat & "', date_n = '" & strDate & "', partic = '" & strPartic & "' " &_
								", DERANCOURSE = " & intDerCourse & ", NBCOURSES = " & intNbCourses & " " &_
								"Where numcyc = " & CInt(Request("numcyc"))),intError,adcmdtext
				End If

			End If
			
			' Test si la mise à jour s'est bien passée
			If intError <> 1 Then
				Conn.RollbackTrans
				Session("strError")="Erreur lors de la mise à jour du cycliste"
				Response.Redirect("modif_cycliste_ok.asp")
			Else
				Conn.CommitTrans
			End If
		
		Else
			Conn.BeginTrans
			Conn.CommandTimeOut=120
			If Application("blnBDDOracle") Then
			
				Conn.Execute ("UPDATE Cycliste " &_
								"Set Nom = '" & strNom & "', Prenom = '" & strPrenom & "', sexe = '" & strSexe &_
								"', Adresse = '" & strAdresse & "', Ville = '" & strVille & "', Cod_post = '" & intCp & "' " &_
								", login = '" & UCase(strLogin) & "', Polit = '" & strPolit & "', Adr_usi = '" & strAdUsine & "', usine = '" & strUsine & "' " &_
								", ASCAP = '" & strASCAP & "', cat = '" & strCat & "', date_n = '" & strDate & "', partic = '" & strPartic & "' " &_
								"Where numcyc = " & CInt(Request("numcyc"))),intError,adcmdtext
			Else
				If strDate = "" Then
					Conn.Execute ("UPDATE Cycliste " &_
									"Set Nom = '" & strNom & "', Prenom = '" & strPrenom & "', sexe = '" & strSexe &_
									"', Adresse = '" & strAdresse & "', Ville = '" & strVille & "', Cod_post = '" & intCp & "' " &_
									", Polit = '" & strPolit & "', Adr_usi = '" & strAdUsine & "', usine = '" & strUsine & "' " &_
									", ASCAP = '" & strASCAP & "', cat = '" & strCat & "', date_n = NULL, partic = '" & strPartic & "' " &_
									"Where numcyc = " & CInt(Request("numcyc"))),intError,adcmdtext
				Else
					Conn.Execute ("UPDATE Cycliste " &_
									"Set Nom = '" & strNom & "', Prenom = '" & strPrenom & "', sexe = '" & strSexe &_
									"', Adresse = '" & strAdresse & "', Ville = '" & strVille & "', Cod_post = '" & intCp & "' " &_
									", Polit = '" & strPolit & "', Adr_usi = '" & strAdUsine & "', usine = '" & strUsine & "' " &_
									", ASCAP = '" & strASCAP & "', cat = '" & strCat & "', date_n = '" & strDate & "', partic = '" & strPartic & "' " &_
									"Where numcyc = " & CInt(Request("numcyc"))),intError,adcmdtext
				End If
				
			End If
			If intError <> 1 Then
				Conn.RollbackTrans
				Session("strError")="Erreur lors de la mise à jour du cycliste"
				Response.Redirect("modif_cycliste_ok.asp")
			Else
			   Conn.CommitTrans
			End If

		End If
		
		' Inscription du cycliste à un circuit
		If CInt(intNumCircuitOld) = 0 AND CInt(intNumCircuit) <> 0 Then
			Conn.BeginTrans
			Conn.CommandTimeOut=120

			Conn.Execute ("INSERT INTO Participer " &_
							"(Numcyc, Numcircuit, Numcourse) " &_
							"Values (" & CInt(Request("numcyc")) & ", " & intNumCircuit & ", " & intNumcourse & ")"),intError,adcmdtext
			
			If intError <> 1 Then
				Conn.RollbackTrans
				Session("strError")="Erreur lors de l'affection du cycliste à un circuit"
				Response.Redirect("modif_cycliste_ok.asp")
			Else
				Conn.CommitTrans
			End If

			' Mise à jour du nombre de participants dans la table course
			Conn.BeginTrans
			Conn.CommandTimeOut=120								
			Conn.Execute ("UPDATE Course " &_
							"Set NbParticipantsTotal = NbParticipantsTotal + 1, NbParticipantsC" & intNumCircuit & " = NbParticipantsC" & intNumCircuit & " + 1" &_
							" Where Numcourse = " & intNumcourse),intError,adcmdtext
			If intError <> 1 Then
				Conn.RollbackTrans
				Session("strError")="Erreur lors de la mise à jour du nombre de participants"
				Response.Redirect("modif_cycliste_ok.asp")
			Else
				Conn.CommitTrans
			End If
			
		ElseIf CInt(intNumCircuitOld) <> CInt(intNumCircuit) Then
		
			' Mise à jour du circuit auquel le cycliste veut participer
			Conn.BeginTrans
			Conn.CommandTimeOut=120
			Conn.Execute ("UPDATE Participer " &_
							"Set Numcircuit = " & intNumCircuit &_
							" Where Numcyc = " & CInt(Request("numcyc")) & "AND Numcourse = " & intNumcourse),intError,adcmdtext
											
			If intError <> 1 Then
				Conn.RollbackTrans
				Session("strError")="Erreur lors de l'affection du cycliste à un circuit"
				Response.Redirect("modif_cycliste_ok.asp")
			Else
			   Conn.CommitTrans
			End If

			' Mise à jour du nombre de participants dans la table Course
			Conn.BeginTrans
			Conn.CommandTimeOut=120
			Conn.Execute ("UPDATE Course " &_
							"Set NbParticipantsC" & intNumCircuit & " = NbParticipantsC" & intNumCircuit & " + 1, NbParticipantsC" & intNumCircuitOld & " = NbParticipantsC" & intNumCircuitOld & " - 1 " &_
							"Where Numcourse = " & intNumcourse),intError,adcmdtext
			If intError <> 1 Then
				Conn.RollbackTrans
				Session("strError")="Erreur lors de la mise à jour du nombre de participants"
				Response.Redirect("modif_cycliste_ok.asp")
			Else
			   Conn.CommitTrans
			End If
											
		End If

		Session("strError") = "Mise à jour effectuée"
		
		If Request("from") <> "" Then
			Response.Redirect("./saisie_" & Request("from") & ".asp?numcyc=" & CInt(Request("numcyc")))
		Else
			Response.Redirect("./modif_cycliste_ok.asp")
		End If

	Else
	
			' Dans le cas de l'ajout d'un cycliste
	
			'strDate = replace(strDate,"/","-")
			'If NOT Application("blnBDDOracle") Then
			'	strDate = "#" & strDate & "#"
			'End If
			
			Set rsNbCourses = Conn.Execute("Select numcourse from course")
			strPartic = ""
			While NOT rsNbCourses.EOF
				strPartic = strPartic & "0"
				rsNbCourses.MoveNext
			Wend
			
			Set rsNbCourses = nothing
			
			' Ajout dans la table cycliste du nouveau cycliste suivant différents critères
			If (Request.Form("login") = "" AND Request.Form("mdp") = "") Then
				intNumcyc = CInt(NumCoureur()) + 1
				Conn.BeginTrans
				Conn.CommandTimeOut=120
				If Application("blnBDDOracle") Then
					Conn.Execute ("INSERT INTO Cycliste " &_
									"(Numcyc, nom, prenom, sexe, adresse, ville, cod_post, login, password, polit, adr_usi, usine, ASCAP, cat, date_n, partic) " &_
									"Values (" & intNumcyc & ", '" & strNom & "', '" & strPrenom & "', '" & strSexe & "', '" & strAdresse & "', '" & strVille & "', '" & intCp & "', '" & UCase(strNom) & "', '" & MD5(UCase(strPrenom)) & "', '" & strPolit & "', '" & strAdUsine & "', '" & strUsine & "', '" & strASCAP & "', '" & strCat & "', '" & strDate & "', '" & strPartic & "')"),intError,adcmdtext
				Else
					If strDate = "" Then
						Conn.Execute ("INSERT INTO Cycliste " &_
										"(Numcyc, nom, prenom, sexe, adresse, ville, cod_post, polit, adr_usi, usine, ASCAP, cat, partic) " &_
										"Values (" & intNumcyc & ", '" & strNom & "', '" & strPrenom & "', '" & strSexe & "', '" & strAdresse & "', '" & strVille & "', '" & intCp & "', '" & strPolit & "', '" & strAdUsine & "', '" & strUsine & "', '" & strASCAP & "', '" & strCat & "', '" & strPartic & "')"),intError,adcmdtext
					Else
						Conn.Execute ("INSERT INTO Cycliste " &_
										"(Numcyc, nom, prenom, sexe, adresse, ville, cod_post, polit, adr_usi, usine, ASCAP, cat,date_n, partic) " &_
										"Values (" & intNumcyc & ", '" & strNom & "', '" & strPrenom & "', '" & strSexe & "', '" & strAdresse & "', '" & strVille & "', '" & intCp & "', '" & strPolit & "', '" & strAdUsine & "', '" & strUsine & "', '" & strASCAP & "', '" & strCat & "', '" & strDate & "', '" & strPartic & "')"),intError,adcmdtext
					End If
							
				End If
				
				If intError <> 1 Then
					Conn.RollbackTrans
					Session("strError")="Erreur lors de l'ajout du cycliste"
					Response.Redirect("ajout_cycliste_ok.asp")
				Else
				   Conn.CommitTrans
				End If
				
				' Inscription du nouveau cycliste à un cicruit							
				If CInt(intNumCircuit) > 0 Then
					Conn.BeginTrans
					Conn.CommandTimeOut=120
					Conn.Execute ("INSERT INTO Participer " &_
									"(Numcyc, Numcircuit, Numcourse) " &_
									"Values (" & intNumcyc & ", " & intNumCircuit & ", " & intNumcourse & ")"),intError,adcmdtext
					
					If intError <> 1 Then
						Conn.RollbackTrans
						Session("strError")="Erreur lors de l'affection du cycliste à un circuit"
						Response.Redirect("ajout_cycliste_ok.asp")
					Else
					   Conn.CommitTrans
					End If

					' Mise à jour du nombre de participants dans la table Course					
					Conn.BeginTrans
					Conn.CommandTimeOut=120
					Conn.Execute ("UPDATE Course " &_
									"Set NbParticipantsTotal = NbParticipantsTotal + 1, NbParticipantsC" & intNumCircuit & " = NbParticipantsC" & intNumCircuit & " + 1" &_
									" Where Numcourse = " & intNumcourse),intError,adcmdtext
									
					If intError <> 1 Then
						Conn.RollbackTrans
						Session("strError")="Erreur lors de la mise à jour du nombre de participants"
						Response.Redirect("ajout_cycliste_ok.asp")
					Else
					   Conn.CommitTrans
					End If
													
				End If
				
				Session("strError") = "Cycliste ajouté !"
				' Redirection
				If Session("strAdmin") = "true" Then
					If Request("from") = "depart" AND Request("submit") <> "" Then
						Response.Redirect("./saisie_depart.asp?numcyc=" & intNumcyc)
					ElseIf Request("from") = "depart" AND Request("go") <> "" Then
						Response.Redirect("./action_saisie_depart.asp?numcircuit=" & intNumCircuit & "&cbnom=" & intNumcyc)
					ElseIf Request("from") = "depart" Then
						Response.Redirect("./saisie_depart.asp")
					Else
						Response.Redirect("./edit_cycliste.asp?mode=new")
					End If
				Else
					Response.Redirect("./ajout_cycliste_ok.asp")
				End If
			
			ElseIf (Request.Form("mdp") = Request.Form("remdp")) Then
				intNumcyc = CInt(NumCoureur()) + 1
				Conn.BeginTrans
				Conn.CommandTimeOut=120
				If Application("blnBDDOracle") Then
					Conn.Execute ("INSERT INTO Cycliste " &_
									"(Numcyc, nom, prenom, sexe, adresse, ville, cod_post, login, password, polit, adr_usi, usine, ASCAP, cat, date_n;, PARTIC) " &_
									"Values (" & intNumcyc & ", '" & strNom & "', '" & strPrenom & "', '" & strSexe & "', '" & strAdresse & "', '" & strVille & "', '" & intCp & "', '" & UCase(strLogin) & "', '" & MD5(UCase(strMdp)) & "', '" & strPolit & "', '" & strAdUsine & "', '" & strUsine & "', '" & strASCAP & "', '" & strCat & "', '" & DateConvert(strDate) & "', '" & strPartic & "')"),intError,adcmdtext
				Else
					If strDate = "" Then
					Conn.Execute ("INSERT INTO Cycliste " &_
									"(Numcyc, nom, prenom, sexe, adresse, ville, cod_post, login, password, polit, adr_usi, usine, ASCAP, cat, PARTIC) " &_
									"Values (" & intNumcyc & ", '" & strNom & "', '" & strPrenom & "', '" & strSexe & "', '" & strAdresse & "', '" & strVille & "', '" & intCp & "', '" & strPolit & "', '" & strAdUsine & "', '" & strUsine & "', '" & strASCAP & "', '" & strCat & "', '" & strPartic & "')"),intError,adcmdtext
					Else
					Conn.Execute ("INSERT INTO Cycliste " &_
									"(Numcyc, nom, prenom, sexe, adresse, ville, cod_post, login, password, polit, adr_usi, usine, ASCAP, cat, date_n, PARTIC) " &_
									"Values (" & intNumcyc & ", '" & strNom & "', '" & strPrenom & "', '" & strSexe & "', '" & strAdresse & "', '" & strVille & "', '" & intCp & "', '" & strPolit & "', '" & strAdUsine & "', '" & strUsine & "', '" & strASCAP & "', '" & strCat & "', '" & strDate & "', '" & strPartic & "')"),intError,adcmdtext
					End If
				End IF
				
				If intError <> 1 Then
					Conn.RollbackTrans
					Session("strError")="Erreur lors de l'ajout du cycliste"
					Response.Redirect("ajout_cycliste_ok.asp")
				Else
				   Conn.CommitTrans
				End If

				
				If CInt(intNumCircuit) > 0 Then
					Conn.BeginTrans
					Conn.CommandTimeOut=120
					Conn.Execute ("INSERT INTO Participer " &_
									"(Numcyc, Numcircuit, Numcourse) " &_
									"Values (" & intNumcyc & ", " & intNumCircuit & ", " & intNumcourse & ")"),intError,adcmdtext

					If intError <> 1 Then
						Conn.RollbackTrans
						Session("strError")="Erreur lors de l'affection du cycliste à un circuit"
						Response.Redirect("ajout_cycliste_ok.asp")
					Else
					   Conn.CommitTrans
					End If
					
					Conn.BeginTrans
					Conn.CommandTimeOut=120
				
					Conn.Execute ("UPDATE Course " &_
									"Set NbParticipantsTotal = NbParticipantsTotal + 1, NbParticipantsC" & intNumCircuit & " = NbParticipantsC" & intNumCircuit & " + 1" &_
									" Where Numcourse = " & intNumcourse),intError,adcmdtext
									
					If intError <> 1 Then
						Conn.RollbackTrans
						Session("strError")="Erreur lors de la mise à jour du nombre de participants"
						Response.Redirect("ajout_cycliste_ok.asp")
					Else
					   Conn.CommitTrans
					End If
												
				End If
				
				Session("strError") = "Cycliste ajouté !"
				If Session("strAdmin") = "true" Then
					If Request("from") = "depart" AND Request("submit") <> "" Then
						Response.Redirect("./saisie_depart.asp?numcyc=" & intNumcyc)
					ElseIf Request("from") = "depart" AND Request("go") <> "" Then
						Response.Redirect("./action_saisie_depart.asp?numcircuit=" & intNumCircuit & "&cbnom=" & intNumcyc)
					ElseIf Request("from") = "depart" Then
						Response.Redirect("./saisie_depart.asp")
					Else
						Response.Redirect("./edit_cycliste.asp?mode=new")
					End If
				Else
					Response.Redirect("./ajout_cycliste_ok.asp")
				End If


			Else
				intNumCyc = Request("numcyc")
				Session("strError") = "Si vous entrez un mot de passe, les deux mots de passe doivent être identiques.<br>"
			End If
		
	End If
' Si on est dans le cas de l'affichage pour l'édition d'un cycliste
ElseIf Request("numedit") <> "" Then

		' Vérification de la session
		If Request("numcyc") = "" Then
			If (Session("intUser") <> CInt(Request("numedit"))) Then
				call TestAdmin
			End If
		Else
			If (Session("intUser") <> CInt(Request("numcyc"))) Then
				call TestAdmin
			End If
		End If
		
		If Request("numedit") <> "" Then
			Set rsCycliste = Conn.Execute ("SELECT * FROM Cycliste WHERE Numcyc = " & Request("numedit"))
		End If
		
		' Récupération des propriétés du cycliste à éditer
		If NOT rsCycliste.EOF Then
			intNumCyc = rsCycliste("Numcyc")
			strPolit = rsCycliste("Polit")
			strNom = rsCycliste("Nom")
			strPrenom = rsCycliste("Prenom")
			strSexe = rsCycliste("Sexe")
			strAdresse = rsCycliste("Adresse")
			strVille = rsCycliste("Ville")
			strUsine = rsCycliste("usine")
			strAdUsine = rsCycliste("Adr_usi")
			strASCAP = rsCycliste("ASCAP")
			strDate = rsCycliste("date_n")
			strCat = rsCycliste("cat")
			intCp = rsCycliste("Cod_post")
			strPartic = rsCycliste("PARTIC")
			If Application("blnBDDOracle") Then
				strLogin = rsCycliste("login")
			End If
		Else 
			Response.Redirect("./liste_cycliste.asp")
		End If
		
		If Request("numedit") <> "" Then
			Set rsCycliste = Conn.Execute ("SELECT * FROM Participer, Course WHERE Participer.Numcourse = Course.Numcourse AND Numcyc = " & Request("numedit") & " AND anneecourse = " & CInt(Year(Now())))
		End If
		
		If NOT rsCycliste.EOF Then
			intNumCircuit = rsCycliste("NumCircuit")
			intNumCourse = rsCycliste("Course.NumCourse")
		Else 
			intNumCircuit = 0
			intNumCourse = 0
		End If
		
		rsCycliste.close
		Set rsCycliste= nothing
Else
		' Dans le cas où il y a des erreurs de saisies
		If Request("mode") = "new" Then
			Session("strError") = Session("strError") & strError
			If ((Request("remdp") <> Request("mdp")) AND Request("mdp") <> "") Then Session("strError") = Session("strError") & "Les deux mots de passes saisis ne correspondent pas.<br>"
		Else
			Session("strError") = strError
		End If
			
		intNumCyc = Request("numcyc")
		strPolit = Request("Polit")
		strNom = Request("nom")
		strPrenom = Request("prenom")
		strSexe = Request("sexe")
		strAdresse = Request("adresse")
		strVille = Request("ville")
		strUsine = Request("usine")
		strAdUsine = Request("AdUsine")
		strASCAP = Request("ascap")
		strDate = Request("date")
		strCat = Request("cat")
		intCp = Request("cp")
		strLogin = Request("login")
		intNumCircuit = Request("distance")
		intNumcourse = Request("numcourse")
		strMdp = ""
		strReMdp = ""
		strPartic = Request("partic")
End If

If (Request("numcyc") = "" AND Request("mode") = "new") Then
	intNumCyc=-1
	Session("strError") = ""
End If
%>
<html>
<head>
<title>Site de gestion de la course de la LIONNE</title>
<%
If Session("intUser") < 0 Then 
	call menu_head
End If
%>
<script src="../Common/common.js" language="JavaScript"></script>
<link href="../style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function load()
{
	edition_cycliste.polit.focus();
}
</script>

</head>
<body>
<% 
call header
If Session("intUser") < 0 Then
	call menu 
End If
%>
<br>
<center>
<H1>
<% If Request("mode") = "edit" Then %>
	Modification d'un cycliste
<% Else %>
	Enregistrement d'un nouveau cycliste
<% End If %>
</H1>
<%
' Affichage de l'erreur le cas échéant

if strOldError<>"" then
%>
<br>
<b><font color="#ff0000">
<% =strOldError %>
</font></b><br>
<% end if 
strOldError="" %>
<p>
<form action="edit_cycliste.asp" method="post" name="edition_cycliste" onSubmit="MM_validateForm('nom','','R','prenom','','R');return document.MM_returnValue">
<input type="hidden" name="numcyc" value="<%=intNumCyc%>">
<input type="hidden" name="mode" value="<%=Request("mode")%>">
<table width="700" border="0">
   <tr>
      <td width="350">Titre</td>
      <td width="350">
	   <select name="polit">
          <option value="">-</option>
<%
' Liste des politesses
Set rsPolitesse = Conn.Execute ("Select ValElt From TLISTES Where nomliste = 'POLITESSE'")

Do While NOT rsPolitesse.EOF
%>
	  <option value="<%=rsPolitesse("ValElt")%>" <% If strPolit = rsPolitesse("ValElt") Then Response.Write("selected") %>><%=rsPolitesse("ValElt")%></option>
<% 
	rsPolitesse.MoveNext
Loop
Set rsPolitesse = nothing
%>
       </select>
	</td>
  </tr>
  <tr>
      <td>Nom *</td>
    <td><input name="nom" type="text" value="<%=strNom%>" maxlength="25">&nbsp;</td>
  </tr>
  <tr>
      <td>Pr&eacute;nom *</td>
    <td><input name="prenom" type="text" value="<%=strPrenom%>" maxlength="20"></td>
  </tr>
  <tr>
    <td colspan="2">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="15%">Sexe</td>
				<td width="10%">
					<select name="sexe">
					  <option value="">-</option>
					  <option value="M" <% If strSexe = "M" Then Response.Write("selected") %>>M</option>
					  <option value="F" <% If strSexe = "F" Then Response.Write("selected") %>>F</option>
					</select>
				</td>
				<td width="15%">&nbsp;</td>
				<td width="30%">Date de Naissance (jj/mm/aaaa)&nbsp;</td>
				<td width="30%">
					<input name="date" type="text" value="<%=strDate%>" size="10" maxlength="10">
				</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td>Adresse</td>
    <td><input name="adresse" type="text" value="<%=strAdresse%>" size="40" maxlength="35"></td>
  </tr>
  <tr>
    <td>Ville</td>
      <td><input name="ville" type="text" value="<%=strVille%>" maxlength="25"></td>
  </tr>
  <tr>
    <td>Code Postal</td>
    <td><input name="cp" type="text" value="<%=intCp%>" size="5" maxlength="5"></td>
  </tr>
  <tr>
    <td colspan="2">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="15%">Usine</td>
				<td width="10%"><input name="usine" type="text" value="<%=strUsine%>" size="4" maxlength="4"></td>
				<td width="15%">&nbsp;</td>
				<td width="30%">Adresse de l'Usine</td>
				<td width="30%"><input name="adusine" type="text" value="<%=strAdUsine%>" maxlength="20"></td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td>N° ASCAP</td>
    <td><input name="ascap" type="text" value="<%=strASCAP%>" maxlength="7"></td>
  </tr>
  <tr>
      <td width="350">Catégorie</td>
    <td>
	   <select name="cat">
       <option value="">-</option>
<%
' Affichage en liste des différentes catégories
Set rsCategorie = Conn.Execute ("Select ValElt From TLISTES Where nomliste = 'CATEGORIE'")

Do While NOT rsCategorie.EOF
%>
	  <option value="<%=rsCategorie("ValElt")%>" <% If strCat = rsCategorie("ValElt") Then Response.Write("selected") %>><%=rsCategorie("ValElt")%></option>
<% 
	rsCategorie.MoveNext
Loop
Set rsCategorie = nothing
%>
       </select>
	</td>
  </tr>
<%	If Request("mode") = "edit" Then %>
  <tr>
  	<td>Partic</td>
	<td><input type="text" name="partic" value="<%=strPartic%>"></td>
  </tr>
<%
	End If
Set rsCourse = Conn.Execute ("Select * From Course Where anneecourse = " & CInt(Year(Now())))

If NOT rsCourse.EOF Then
%>
  <tr>
	<td align="center" colspan="2"><br>
	<input type="hidden" value="" name="go">
	<input type="hidden" value="<%=Request("from")%>" name="from">
	<input type="hidden" value="<%=rsCourse("numcourse")%><% 'If intNumCourse = "" Then Response.Write(rsCourse("numcourse")) Else Response.Write(intNumCourse)%>" name="numcourse">
	<input type="hidden" value="<%=CInt(intNumCircuit)%>" name="numcircuitold">
	<input name="distance" type="radio" value="1" <%If CInt(intNumCircuit) = 1 Then Response.Write("checked")%>>&nbsp;Circuit 1 (<%=rsCourse("distanceC1")%> km)&nbsp;&nbsp;
	<input name="distance" type="radio" value="2" <%If CInt(intNumCircuit) = 2 Then Response.Write("checked")%>>&nbsp;Circuit 2 (<%=rsCourse("distanceC2")%> km)&nbsp;&nbsp;
	<input name="distance" type="radio" value="3" <%If CInt(intNumCircuit) = 3 Then Response.Write("checked")%>>&nbsp;Circuit 3 (<%=rsCourse("distanceC3")%> km)&nbsp;
	</td>
  </tr>
<%
Else
%>
  <tr>
  	<td align="center" colspan="2">
	<br>
<H2><i>Pas de préinscription possible actuellement</i></H2>
	</td>
  </tr>

<%
End If
%>
<% If Request("mode") = "edit" Then
		If Application("blnBDDOracle") Then
%>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td>Login</td>
    <td><input name="login" type="text" value="<%=strLogin%>" maxlength="14"></td>
  </tr>
<%
		End If
	If Request("from") <> "" AND Request("mode") = "edit" Then
%>
  <tr>
  	<td colspan="2" align="center"><br><br>
	<input type="submit" name="Submit" value="Enregistrer">&nbsp;&nbsp;
	<input type="button" name="retour" value="Retour" onClick="window.location.replace('saisie_<%=Request("from")%>.asp?numcyc=<%=intNumcyc%>');">&nbsp;&nbsp;
	<input type="button" name="supprimer" value="Supprimer" onClick="window.location.replace('suppr_cycliste.asp?numcyc=<%=intNumcyc%>');">
	</td>
  </tr>
<%	Else %>
  <tr>
  	<td colspan="2" align="center"><br><br>
	<input type="submit" name="Submit" value="Enregistrer">
	&nbsp;&nbsp;
	<input type="button" name="supprimer" value="Supprimer" onClick="window.location.replace('suppr_cycliste.asp?numcyc=<%=intNumcyc%>');">
	</td>
  </tr>
<%	End If %>
</table>

<% If Application("blnBDDOracle") Then %>
<br>
<center><a href="./modif_password.asp?numcyc=<%=intNumcyc%>">Modifier le mot de passe</a></center>
<% End If %>
<br>
<% 
Else
	If Application("blnBDDOracle") Then
%>
  <tr>
  	<td align="center" colspan="2">
		<br>
		<h2>
		<i>Login et mot de passe de connexion</i>
		</h2>
	</td>
  </tr>
  <tr>
    <td width="350">Login </td>
    <td><input name="login" type="text" value="<%=strLogin%>" maxlength="14"></td>
  </tr>
	<input type="hidden" name="changemdp" value="on">
  <tr>
    <td>Mot de passe</td>
    <td><input name="mdp" type="password" maxlength="14"></td>
  </tr>
  <tr>
    <td>Entrer à nouveau votre mot de passe</td>
    <td><input name="remdp" type="password" maxlength="14"></td>
  </tr>
  <tr>
  	<td colspan="2"><br>
		<i>Ces champs sont facultatifs, votre login sera alors votre nom<br>et votre mot de passe sera votre prénom.</i>
	</td>
  </tr>
<% 
	End If
	If Request("from") <> "" AND Request("mode") = "new" Then %>
  <tr>
  	<td colspan="2" align="center"><br><br>
	<input type="submit" name="Submit" value="Enregistrer">&nbsp;&nbsp;
	<input type="submit" name="go" value="Enregistrer et démarrer le cycliste">&nbsp;&nbsp;
	<input type="button" name="retour" value="Retour" onClick="window.location.replace('saisie_<%=Request("from")%>.asp');">
	</td>
  </tr>
<%	Else %>
  <tr>
  	<td colspan="2" align="center"><br><br>
	<input type="submit" name="Submit" value="Enregistrer">
	</td>
  </tr>
<%	End If %>
</table>
<% End If %>
</form>
<%
' Affichage de l'erreur le cas échéant

if Session("strError")<>"" then
%>
<br>
<b><font color="#ff0000">
<% =Session("strError") %>
</font></b>
<% end if 
Session("strError")="" %>
<font size="-1"><i>Les champs avec * sont obligatoires.</i></font>
<br><br>
<% If Session("strAdmin") = "true" Then %>
<input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
<% Else %>
<input type="button" value="Retour à l'accueil" onclick="window.location.replace('../default.asp');">
<% End If %>
</center>
</body>
</html>
<!--#include file="../Common/kill.asp" -->