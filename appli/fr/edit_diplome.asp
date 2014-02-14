<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Formatage des diplômes
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin


Dim rsDiplome
set rsDiplome = Server.CreateObject("ADODB.recordset")


Dim strSQL
strSQL="SELECT * FROM DIPLOME WHERE ID=1"
rsDiplome.Open strSQL,Conn,adOpenForwardOnly,adLockReadOnly
if rsDiplome.EOF then
Session("strError")="Impossible charger les données concernant le diplôme!"
response.redirect "index_admin.asp"
end if

%>

<html>



    <script>
        var g_posCurseur; // variable global positition du curseur

        //définit la postition du curseur
        function setPosCurseurTitre() {
            g_posCurseur = getPosCurseurTitre(mForm.titre);
        }

        //retourne l'emplacement du curseur
        function getPosCurseurTitre(oTextArea) {
            //sauve le contenu avant modification de la zone de texte
            var sAncienTexte = oTextArea.value;

            //crer un objet "Range Objet" et sauve son texte avant modification
            var oRange = document.selection.createRange();
            var sAncRangeTexte = oRange.text;
            //cette chaine ne doit pas se retrouver dans la zone de texte !
            var sMarquer = String.fromCharCode(28) + String.fromCharCode(29) + String.fromCharCode(30);

            //insère la chaine où le curseur est
            oRange.text = sAncRangeTexte + sMarquer;
            oRange.moveStart('character', (0 - sAncRangeTexte.length - sMarquer.length));

            //sauver la nouvelle chaine
            var sNouvTexte = oTextArea.value;

            //remet la valeur du texte à son ancienne valeur
            oRange.text = sAncRangeTexte;

            //recherche dans la nouvelle chaine et trouve l'emplacement
            // de la chaîne de marquage et renvoie la position
            for (i = 0; i <= sNouvTexte.length; i++) {
                var sTemp = sNouvTexte.substring(i, i + sMarquer.length);
                if (sTemp == sMarquer) {
                    var cursorPos = (i - sAncRangeTexte.length);
                    return cursorPos;
                }
            }
        }

        //insère la chaine dans la zone de texte où le curseur est
        function insereChaineTitre(sChaine) {
            //si curseur n'a pas de position : insère la chaine à la fin
            if (typeof (g_posCurseur) == 'undefined') {
                mForm.titre.value += sChaine;
            } else {
                var firstPart = mForm.titre.value.substring(0, g_posCurseur);
                var secondPart = mForm.titre.value.substring(g_posCurseur, mForm.titre.value.length);
                mForm.titre.value = firstPart + sChaine + secondPart;
            }
        }






        //Pour le corps

        var g_posCurseur2; // variable global positition du curseur

        //définit la postition du curseur
        function setPosCurseurCorps() {
            g_posCurseur2 = getPosCurseurCorps(mForm.corps);
        }

        //retourne l'emplacement du curseur
        function getPosCurseurCorps(oTextArea) {
            //sauve le contenu avant modification de la zone de texte
            var sAncienTexte = oTextArea.value;

            //crer un objet "Range Objet" et sauve son texte avant modification
            var oRange = document.selection.createRange();
            var sAncRangeTexte = oRange.text;
            //cette chaine ne doit pas se retrouver dans la zone de texte !
            var sMarquer = String.fromCharCode(28) + String.fromCharCode(29) + String.fromCharCode(30);

            //insère la chaine où le curseur est
            oRange.text = sAncRangeTexte + sMarquer;
            oRange.moveStart('character', (0 - sAncRangeTexte.length - sMarquer.length));

            //sauver la nouvelle chaine
            var sNouvTexte = oTextArea.value;

            //remet la valeur du texte à son ancienne valeur
            oRange.text = sAncRangeTexte;

            //recherche dans la nouvelle chaine et trouve l'emplacement
            // de la chaîne de marquage et renvoie la position
            for (i = 0; i <= sNouvTexte.length; i++) {
                var sTemp = sNouvTexte.substring(i, i + sMarquer.length);
                if (sTemp == sMarquer) {
                    var cursorPos = (i - sAncRangeTexte.length);
                    return cursorPos;
                }
            }
        }

        //insère la chaine dans la zone de texte où le curseur est
        function insereChaineCorps(sChaine) {
            //si curseur n'a pas de position : insère la chaine à la fin
            if (typeof (g_posCurseur2) == 'undefined') {
                mForm.corps.value += sChaine;
            } else {
                var firstPart = mForm.corps.value.substring(0, g_posCurseur2);
                var secondPart = mForm.corps.value.substring(g_posCurseur2, mForm.corps.value.length);
                mForm.corps.value = firstPart + sChaine + secondPart;
            }
        }


    </script> 

    <SCRIPT language="javascript">
        function ValiderTexte() {

            document.mForm.titre.value = escape(document.mForm.titre.value);
            document.mForm.corps.value = escape(document.mForm.corps.value);
            return true;

        }

    </SCRIPT>


    <script type="text/javascript">
        function load()
        {
            mForm.titre.focus();
        }
    </script>

    <% call menu_head %>


    <link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body>
    <% 
    call header
    call menu 
    %>
    <div id="wrapper">
        <center>

            <h1>EDITION DU FORMAT DES DIPLOMES</h1>


            <%
            ' Affichage de l'erreur le cas échéant

            if Session("strError")<>"" then
            %>
            <br>
            <b><font color="#ff0000">
                <% =Session("strError") %>
                </font></b>
            <br><br>

            <% end if 
            Session("strError")="" %>






            <form name="mForm" action="action_edit_diplome.asp" method="post" onSubmit="return ValiderTexte();">
                <H3>Titre du diplôme</H3>
                <input type="button" value="Gras" onclick="insereChaineTitre('[gras][/gras]');">
                <input type="button" value="Italique" onclick="insereChaineTitre('[italique][/italique]');">
                <input type="button" value="Titre" onclick="insereChaineTitre('[titre][/titre]');">
                <input type="button" value="Retour ligne" onclick="insereChaineTitre('[retour_ligne]');">
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="Politesse" onclick="insereChaineTitre('[politesse]');">
                <input type="button" value="Prénom" onclick="insereChaineTitre('[prenom]');">
                <input type="button" value="Nom" onclick="insereChaineTitre('[nom]');">
                <input type="button" value="Année" onclick="insereChaineTitre('[annee]');">
                <input type="button" value="Date" onclick="insereChaineTitre('[date]');">
                <input type="button" value="N° circuit" onclick="insereChaineTitre('[numcircuit]');">
                <input type="button" value="Distance" onclick="insereChaineTitre('[distance]');">
                <input type="button" value="Nb Courses" onclick="insereChaineTitre('[nbcourses]');">
                <br>
                <textarea name="titre" cols="120" rows="5" ONCHANGE="setPosCurseurTitre()" ONCLICK="setPosCurseurTitre()"><% =unescape(rsDiplome("TITRE"))%></textarea>
                <br><br>
                <H3>Corps du diplôme</H3>
                <input type="button" value="Gras" onclick="insereChaineCorps('[gras][/gras]');">
                <input type="button" value="Italique" onclick="insereChaineCorps('[italique][/italique]');">
                <input type="button" value="Titre" onclick="insereChaineCorps('[titre][/titre]');">
                <input type="button" value="Retour ligne" onclick="insereChaineCorps('[retour_ligne]');">
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="Politesse" onclick="insereChaineCorps('[politesse]');">
                <input type="button" value="Prénom" onclick="insereChaineCorps('[prenom]');">
                <input type="button" value="Nom" onclick="insereChaineCorps('[nom]');">
                <input type="button" value="Année" onclick="insereChaineCorps('[annee]');">
                <input type="button" value="Date" onclick="insereChaineCorps('[date]');">
                <input type="button" value="N° circuit" onclick="insereChaineCorps('[numcircuit]');">
                <input type="button" value="Distance" onclick="insereChaineCorps('[distance]');">
                <input type="button" value="Nb Courses" onclick="insereChaineCorps('[nbcourses]');">
                <br>
                <textarea name="corps" cols="120" rows="10" ONCHANGE="setPosCurseurCorps()" ONCLICK="setPosCurseurCorps()"><% =unescape(rsDiplome("CORPS"))%></textarea>



                <br><br>
                <input type="submit" value="Enregistrer">
                <input type="button" value="Retour à l'accueil" onclick="window.location.replace('index_admin.asp');">
            </form>
        </center>
    </div>
</body>
</html>
<%
rsDiplome.close
set rsDiplome=Nothing 
%>

<!--#include file="../common/kill.asp"-->