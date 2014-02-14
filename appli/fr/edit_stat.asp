<!--#include file="../common/init.asp"-->

<%
'Accès uniquement aux admins
call TestAdmin

if Request.QueryString("mode")<>"new" then
Dim rsCourse
set rsCourse = Server.CreateObject("ADODB.recordset")
rsCourse.Open "Select * from COURSE ORDER BY NUMCOURSE DESC",Conn,adOpenForwardOnly,adLockReadOnly
end if
%>
<html>
    <head>
        <% call menu_head %>
        <script type="text/javascript">
            function change_course()
            {
                var url = 'action_stat.asp?numcourse=' + document.form1.numcourse.value;
                window.location.replace(url);
            }
        </script>
    </head>
    <body>
        <% 
        call header
        call menu 
        %>
        <div id="wrapper">
            <center>
                <%
                if Request.QueryString("mode")="new" then
                %>
                <H1>AJOUT D'UNE COURSE</H1>
                <%
                else
                %>
                <H1>CONSULTATION DES COURSES</H1>
                <%
                end if
                %>
                <br><br><br>
                <form name="form1" action="action_stat.asp" method="post">
                    <table border="0">

                        <tr>
                            <td align=right><b>Année de la Course&nbsp;</b></td><td>

                                <%
                                if Request.QueryString("mode")="new" then
                                %>
                                IL FAUT RECUPER LE NOUVEAU NUMERO A METTRE ICI
                                <input type="text" name="numcourse" size="4" maxlength="4" readonly style="background: #e6e6e6; font: bold">
                                <%
                                else
                                %>
                                <select name="numcourse" onchange="change_course()" style="background: #e6e6e6; font: bold">
                                    <option value="  "></option>"
                                    <%
                                    Dim num
                                    dim ann
                                    while not rsCourse.EOF
                                    ann=rsCourse("anneecourse")
                                    num=rsCourse("numcourse")
                                    response.write("<option value=" & num & ">" & ann & "</option>")	
                                    rsCourse.MoveNext
                                    Wend
                                    %>
                                </select>
                                <%
                                end if
                                %>
                    </table>
                </form>
        </div>
    </body>
</html>

<!--#include file="../common/kill.asp"-->