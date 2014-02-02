//Portion d'ajax ici


//instance de l'objet
function createXHR(){
var xhr = null;
	try 
	{	
		xhr = new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(Error)
	{	
		try
		{
		 xhr = new ActiveXObject("Microsoft.XMLHTTP");
		}
		catch(Error)
		{
			try  //fonctionnel avec 4<ie<=7
			{
				var xhr = new XMLHttpRequest();
			}catch(Error)
			{
				alert("Internet Explorer must DIE");
			}
		}
	}
	return xhr;
}

/*

IN : element input type text id='defaut'

OUT : affiche les resultats contenant les lettres frappé dans l'élément 


*/
function getCoucou(){

	
	var xhr = createXHR();
	var data ="codeDef=";
	
		xhr.open('get','../common/handlerxhr.asp',true);
		xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhr.onreadystatechange= function()
		{	
			if(xhr.readyState==4 && xhr.status==200)
				{
					document.getElementById('tst').innerHTML=xhr.responseText;
					//alert(xhr.responseText);
				}
		}
		
		xhr.send();
}

