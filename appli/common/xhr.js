//Le COEUR D'AJAX


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


