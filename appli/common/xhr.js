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


function getCyclistes(el){

	if(el.value!="")
	{
		var xhr = createXHR();
		var data="search="+el.value;
	
				xhr.open('POST','../common/HandlerXhr.php',true);
				xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				xhr.onreadystatechange= function()
				{	
					if(xhr.readyState==4 && xhr.status==200)
					{
						showCyc(xhr.responseXML);
					}
				}
				xhr.send(data);
	}else
	{
		return;
	}
}

/*Affiche un select avec une liste de cycliste trié 
	id de l'input cible : num
	
	ajouter <div 
*/
	function showCyc(xml){

		var els = xml.getElementsByTagName('cycliste') || 0;
		var test = document.getElementById('num');
		var res =document.getElementById('autocomp') || document.getElementByName('autocomp');
	 	var num=0;
		res.innerHTML="";
		//si un seul résultat alors on le valide automatiquement
		if(els.length==1)
		{
			var buf = els[0].childNodes.item(0).textContent || els[0].childNodes.item(0).text;
			
			getCycliste(buf);
			res.style.display="none";
			
			return;
		}
		var num=0;
		for(i=0,div;i<els.length;i++)
		{
			
			var div = res.appendChild(document.createElement('div'));
			num = els[i].childNodes.item(0).textContent || els[i].childNodes.item(0).text;
			var buf = num;
			buf+=" ";
			buf+=els[i].childNodes.item(1).textContent || els[i].childNodes.item(1).text;
			buf+=" ";
			buf+=els[i].childNodes.item(2).textContent || els[i].childNodes.item(2).text;
			var input = document.createElement('input');
			
			var in1=document.createElement('input');
			in1.type='hidden';
			in1.id='numcycAuto';	
			in1.value=num;
			
			var text = document.createTextNode(buf );
			div.appendChild(in1);
			div.appendChild(text);
			
			div.onclick= function()
			{
				getCycliste(this.firstChild.value);
			};
		}	

		res.style.left = test.offsetLeft+"px";
		res.style.top = (test.offsetTop+25)+"px";
		res.style.display = els.length ? 'block':'none'; //affichage des resultats s'il y en a
	}