<!--#include file="../common/init.asp"-->
<% call TestAdmin %>
<html>
	<head>
		<% call menu_head %>
	</head>
	<body>
		<% 
			call header
			call menu 
		%>
		<center>
			<h2>Accueil Administrateur de la Course de la Lionne</h2>
			</br>
			</br>
			<%
				' Affichage de l'erreur le cas �ch�ant
				if Session("strError")<>"" then
			%>
			<br>
			<b>
				<font color="#ff0000">
				<% =Session("strError") %>
				</font>
			</b>
			</br>
			</br>
			<% end if 
			Session("strError")="" %>
			</br>
			</br>
			</br>
			</br>
			Veuillez utiliser le menu pour accc�der aux diff�rentes fonctionnalit�s du site.
		</center>
	</body>
</html>
<!--#include file="../common/kill.asp"-->