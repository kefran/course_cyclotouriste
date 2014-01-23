<%
'Fichier vérifiant si l'utilisateur s'est bien authentifié en tant qu'administrateur
sub TestAdmin
	
	if Session("strAdmin")="false" then
		Session("strError")="Vous n'êtes pas authentifié comme administrateur de la course!"
		response.redirect "../default.asp"
	end if
end sub


'Fichier vérifiant si l'utilisateur s'est bien authentifié en tant qu'utilisateur
sub TestUser

	if Session("intUser")<=0 then
		Session("strError")="Vous n'êtes pas authentifié!"
		response.redirect "../default.asp"
	end if
end sub


'Fichier vérifiant si l'utilisateur s'est bien authentifié en tant qu'utilisateur ou alors que c'est un nouvel utilisateur qui souhaite s'inscrire ou que c'est un admin
sub TestNewUserOrAdmin
	
	if Session("intUser")<0 then
		if Session("strAdmin")="false" then
			Session("strError")="Vous n'êtes pas authentifié!"
			response.redirect "../default.asp"
		end if
	end if
end sub

'Fichier vérifiant si l'utilisateur s'est bien authentifié en tant qu'utilisateur ou en admin
sub TestUserOrAdmin
	
	if Session("intUser")<1 then
		if Session("strAdmin")="false" then
			Session("strError")="Vous n'êtes pas authentifié!"
			response.redirect "../default.asp"
		end if
	end if
end sub

%>
