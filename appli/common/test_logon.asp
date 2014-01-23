<%
'Fichier v�rifiant si l'utilisateur s'est bien authentifi� en tant qu'administrateur
sub TestAdmin
	
	if Session("strAdmin")="false" then
		Session("strError")="Vous n'�tes pas authentifi� comme administrateur de la course!"
		response.redirect "../default.asp"
	end if
end sub


'Fichier v�rifiant si l'utilisateur s'est bien authentifi� en tant qu'utilisateur
sub TestUser

	if Session("intUser")<=0 then
		Session("strError")="Vous n'�tes pas authentifi�!"
		response.redirect "../default.asp"
	end if
end sub


'Fichier v�rifiant si l'utilisateur s'est bien authentifi� en tant qu'utilisateur ou alors que c'est un nouvel utilisateur qui souhaite s'inscrire ou que c'est un admin
sub TestNewUserOrAdmin
	
	if Session("intUser")<0 then
		if Session("strAdmin")="false" then
			Session("strError")="Vous n'�tes pas authentifi�!"
			response.redirect "../default.asp"
		end if
	end if
end sub

'Fichier v�rifiant si l'utilisateur s'est bien authentifi� en tant qu'utilisateur ou en admin
sub TestUserOrAdmin
	
	if Session("intUser")<1 then
		if Session("strAdmin")="false" then
			Session("strError")="Vous n'�tes pas authentifi�!"
			response.redirect "../default.asp"
		end if
	end if
end sub

%>
