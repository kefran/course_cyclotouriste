<%
'******************************************
'Par Julien LAB et Valentin BIAUZON 2004
'******************************************
'
'Affichage des statistiques d’une année donnée
'
'******************************************
%>

<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin
%>
<html>
    <head>
        <% call menu_head %>
    </head>
    <body>
        <% 
        call header
        call menu 
        %>
        <div id="wrapper">
            <center>
                <H1>STATISTIQUES</H1>

                <%
                dim sex
                sex="F"
                dim var
                var=1
                var=request.querystring("numcourse")

                Dim rsCourses
                set rsCourses = Server.CreateObject("ADODB.recordset")
                rsCourses.Open "SELECT count(*) as nb FROM cycliste",Conn,adOpenForwardOnly,adLockReadOnly
                %>


                <table border="0">
                    <tr>

                        <td width="250" valign="middle"><b>Nombre de personnes du fichier&nbsp;</b></td>
                        <td valign="middle"> <%
                            response.write( rsCourses("nb"))
                            %>
                        </td>
                    </tr>

                    <tr>
                        <td width="250" valign="middle"><b>Nombre de départs déjà pris&nbsp;<br></b></td>
                        <td  valign="middle">
                            <% 
                            dim dep
                            Dim rCourses
                            set rCourses = Server.CreateObject("ADODB.recordset")
                            rCourses.Open "SELECT count(participer.numcyc)as nb FROM participer, cycliste, course WHERE cycliste.numcyc=participer.numcyc And participer.numcourse=course.numcourse And course.numcourse=" & var & " And participer.hdepart Is Not Null",Conn,adOpenForwardOnly,adLockReadOnly
                            %><%
                            = rCourses("nb") %><%
                            dep=rCourses("nb")
                            %>
                        </td>
                    </tr>

                    <tr>
                        <td width="250" valign="middle"><b><br>Nombre de retours saisis&nbsp;<br></b></td>
                        <td  valign="middle">
                            <% 
                            dim ret
                            Dim rCourse
                            set rCourse = Server.CreateObject("ADODB.recordset")
                            rCourse.Open "SELECT count(*) as nb FROM participer, course WHERE participer.numcourse=" & var & " And participer.numcourse=course.numcourse And participer.harrivee Is Not Null",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write( rCourse("nb"))
                            ret = rCourse("nb")
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td width="250" ><b>Nombre de personnes non rentrées&nbsp;</b></td>
                        <td  valign="middle">  <%   
                            dim encourse
                            encourse= CInt(dep)-CInt(ret)
                            response.write(encourse) %> </td>
                    </tr>

                    <tr>
                        <% 
                        Dim lg1
                        set lg1 = Server.CreateObject("ADODB.recordset")
                        lg1.Open "SELECT distancec1 FROM course WHERE numcourse=" & var,Conn,adOpenForwardOnly,adLockReadOnly
                        %>


                        <td width="250" ><b>Nombre de départ&nbsp<%response.write(lg1("distancec1"))%>  &nbspKM&nbsp;</b></td>
                        <td>
                            <% 
                            Dim rCour
                            set rCour = Server.CreateObject("ADODB.recordset")
                            rCour.Open "SELECT count(*) as nb FROM participer, course WHERE participer.numcourse=" & var & " And participer.numcircuit=1 And participer.numcourse=course.numcourse And participer.hdepart Is Not Null",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write( rCour("nb"))
                            Dim rCourf
                            set rCourf = Server.CreateObject("ADODB.recordset")
                            rCourf.Open "SELECT count(*) as nbf FROM participer, course, cycliste WHERE  participer.numcourse=" & var & " and participer.numcircuit=1 And participer.numcourse=course.numcourse And participer.hdepart Is Not Null  and participer.numcyc=cycliste.numcyc and cycliste.sexe='" & sex & "'",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write(" dont "& rCourf("nbf"))
                            if (CInt(rCourf("nbf")))=1 then
                            response.write(" femme")
                            elseif (CInt(rCourf("nbf")))=0 then
                            response.write(" femme")
                            else
                            response.write(" femmes")
                            end if
                            %>
                        </td>
                    </tr>
                    <% 
                    Dim lg2
                    set lg2 = Server.CreateObject("ADODB.recordset")
                    lg2.Open "SELECT distancec2 FROM course WHERE numcourse=" & var,Conn,adOpenForwardOnly,adLockReadOnly
                    %>
                    <% 
                    Dim lg3
                    set lg3 = Server.CreateObject("ADODB.recordset")
                    lg3.Open "SELECT distancec3 FROM course WHERE numcourse=" & var,Conn,adOpenForwardOnly,adLockReadOnly
                    %>
                    <tr>
                        <td width="250" ><b>Nombre de départ  &nbsp<%response.write(lg2("distancec2"))%>&nbspKM&nbsp;</b></td>
                        <td>
                            <% 
                            Dim rCou
                            set rCou = Server.CreateObject("ADODB.recordset")
                            rCou.Open "SELECT count(*) as nb FROM participer, course WHERE participer.numcourse=" & var & " And participer.numcircuit=2 And participer.numcourse=course.numcourse And participer.hdepart Is Not Null",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write( rCou("nb"))
                            Dim rCouf
                            set rCouf = Server.CreateObject("ADODB.recordset")
                            rCouf.Open "SELECT count(*) as nbf FROM participer, course, cycliste WHERE  participer.numcourse=" & var & " and participer.numcircuit=2 And participer.numcourse=course.numcourse And participer.hdepart Is Not Null  and participer.numcyc=cycliste.numcyc and cycliste.sexe='" & sex & "'",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write(" dont "& rCouf("nbf"))
                            if (CInt(rCouf("nbf")))=1 then
                            response.write(" femme")
                            elseif (CInt(rCouf("nbf")))=0 then
                            response.write(" femme")
                            else
                            response.write(" femmes")
                            end if
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td width="250" ><b>Nombre de départ &nbsp<% response.write(lg3("distancec3"))%> &nbspKM&nbsp;</b></td>
                        <td>
                            <% 
                            Dim rCo
                            set rCo = Server.CreateObject("ADODB.recordset")
                            rCo.Open "SELECT count(*) as nb FROM participer, course WHERE participer.numcourse=" & var & " And participer.numcircuit=3 And participer.numcourse=course.numcourse And participer.hdepart Is Not Null",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write( rCo("nb"))
                            Dim rCof
                            set rCof = Server.CreateObject("ADODB.recordset")
                            rCof.Open "SELECT count(*) as nbf FROM participer, course, cycliste WHERE  participer.numcourse=" & var & " and participer.numcircuit=3 And participer.numcourse=course.numcourse And participer.hdepart Is Not Null  and participer.numcyc=cycliste.numcyc and cycliste.sexe='" & sex & "'",Conn,adOpenForwardOnly,adLockReadOnly
                            response.write(" dont "& rCof("nbf"))
                            if (CInt(rCof("nbf")))=1 then
                            response.write(" femme")
                            elseif (CInt(rCof("nbf")))=0 then
                            response.write(" femme")
                            else
                            response.write(" femmes")
                            end if
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td width="250" ><b>Le participant le plus âgé&nbsp;</b></td>
                        <td>
                            <% 
                            dim datevieu
                            dim age
                            set datevieu = Server.CreateObject("ADODB.recordset")
                            datevieu.Open "SELECT Min(cycliste.DATE_N) AS mindate FROM cycliste, participer WHERE participer.NumCourse=" & var & " and cycliste.NUMCYC=participer.numcyc",Conn,adOpenForwardOnly,adLockReadOnly
                            if (datevieu.EOF)="Faux" then
                            age=datevieu("mindate")
                            dim vieu
                            set vieu = Server.CreateObject("ADODB.recordset")

                            if Application("blnBDDOracle")=true then
                            vieu.Open "SELECT nom, prenom,ville  FROM cycliste, participer WHERE participer.numcyc=cycliste.numcyc and participer.numcourse=" & var & " and date_n=TO_DATE('"&age&"','dd/mm/yy')",Conn,adOpenForwardOnly,adLockReadOnly
                            else
                            vieu.Open "SELECT nom, prenom,ville  FROM cycliste, participer WHERE participer.numcyc=cycliste.numcyc and participer.numcourse=" & var & " and date_n like'"&age&"%'",Conn,adOpenForwardOnly,adLockReadOnly
                            end if

                            if (vieu.EOF)="Faux" then
                            response.write(vieu("nom")&"  "&vieu("prenom")&"  "&vieu("ville")&"  "&age)
                            else
                            response.write("Pas de coureur entré pour cette course")
                            end if
                            //Dim vieu
                            //set vieu = Server.CreateObject("ADODB.recordset")
                            //vieu.Open "SELECT cycliste.NOM, cycliste.PRENOM, cycliste.DATE_N, cycliste.VILLE FROM cycliste, participer WHERE (((cycliste.NUMCYC)=[participer].[numcyc]) AND ((participer.NumCourse)=" & var & ") AND ((Now()-[date_n])=(SELECT max(Now()-date_n) FROM cycliste, participer where cycliste.numcyc=participer.numcyc and participer.numcourse=" & var & ")))",Conn,adOpenForwardOnly,adLockReadOnly
                            //if (vieu.EOF)="Faux" then
                            //response.write( vieu("nom")&"  " & vieu("prenom")&"  " & vieu("date_n")&"  " &vieu("ville"))
                            else
                            response.write("Pas de coureur entré pour cette course")
                            end if
                            %>


                        </td>
                    </tr>

                    <tr>
                        <td width="250" ><b>Le plus jeune participant&nbsp;</b></td>
                        <td>
                            <% 
                            dim datejeun
                            dim agej
                            set datejeun = Server.CreateObject("ADODB.recordset")
                            datejeun.Open "SELECT Max(cycliste.DATE_N) AS mindate FROM cycliste, participer WHERE participer.NumCourse=" & var & " and cycliste.NUMCYC=participer.numcyc",Conn,adOpenForwardOnly,adLockReadOnly
                            if (datejeun.EOF)="Faux" then
                            agej=datejeun("mindate")
                            dim jeun
                            set jeun = Server.CreateObject("ADODB.recordset")

                            if Application("blnBDDOracle")=true then		
                            jeun.Open "SELECT nom, prenom,ville  FROM cycliste, participer WHERE participer.numcyc=cycliste.numcyc and participer.numcourse=" & var & " and date_n=TO_DATE('"&agej&"','dd/mm/yy')",Conn,adOpenForwardOnly,adLockReadOnly
                            else
                            jeun.Open "SELECT nom, prenom,ville  FROM cycliste, participer WHERE participer.numcyc=cycliste.numcyc and participer.numcourse=" & var & " and date_n like '"&agej&"%'",Conn,adOpenForwardOnly,adLockReadOnly
                            end if

                            if (jeun.EOF)="Faux" then
                            %>
                            <% =(jeun("nom")&"  "&jeun("prenom")&"  "&jeun("ville")&"  "&agej) %>
                            <%
                            else
                            %>
                            Pas de coureur entré pour cette course
                            <%
                            end if
                            //Dim vieu
                            //set vieu = Server.CreateObject("ADODB.recordset")
                            //vieu.Open "SELECT cycliste.NOM, cycliste.PRENOM, cycliste.DATE_N, cycliste.VILLE FROM cycliste, participer WHERE (((cycliste.NUMCYC)=[participer].[numcyc]) AND ((participer.NumCourse)=" & var & ") AND ((Now()-[date_n])=(SELECT max(Now()-date_n) FROM cycliste, participer where cycliste.numcyc=participer.numcyc and participer.numcourse=" & var & ")))",Conn,adOpenForwardOnly,adLockReadOnly
                            //if (vieu.EOF)="Faux" then
                            //response.write( vieu("nom")&"  " & vieu("prenom")&"  " & vieu("date_n")&"  " &vieu("ville"))
                            else
                            %>
                            Pas de coureur entré pour cette course
                            <%
                            end if
                            %>
                        </td>
                    </tr>
                </table>
                <br><br>
                <br>

                <!-- DEBUT DU SCRIPT IMPRIMER-->
                <p align="center"><a href="javascript:window.print()">
                        <img src="image.jpg" width="37" height="39"></a></p>
                <!-- FIN DU SCRIPT IMPRIMER-->
                <input type="button" value="Retour à l'accueil de l'administration" onclick="window.location.replace('index_admin.asp');">
                </div>
                </body>
                </html>

                <!--#include file="../common/kill.asp"-->






