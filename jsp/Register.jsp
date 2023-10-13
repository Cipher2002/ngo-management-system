<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.http.*"%>

<%
    // Check if the page has already been reloaded
    if (session.getAttribute("pageReloaded") == null) {
        session.setAttribute("pageReloaded", true);
%>
    <script>
        // Reload the page once after the user details are displayed
        window.onload = function() {
            window.location.reload(true); // true forces a full reload from the server
        };
    </script>
<%
    }
%>

<%
   try
    {
    String str1 = request.getParameter("authorisationId");
    String str7 = request.getParameter("zip");
    String str2 = request.getParameter("ngoName");
    String str3 = request.getParameter("address1");
    String str4 = request.getParameter("address2");
    String str5 = request.getParameter("city");
    String str6 = request.getParameter("state");
    String str8 = request.getParameter("summary");
    String str9 = request.getParameter("mapsLink");
	String str10 = request.getParameter("pass");

    String str = "Insert into ngos(ngoid, ngoname, addl1, addl2, city, state, zipcode, prof, pass, lurl) values (?,?,?,?,?,?,?,?,?,?)";

    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "root");
	
    PreparedStatement smt = con.prepareStatement(str);
	
    smt.setString(1,str1);
    smt.setString(2, str2);
    smt.setString(3, str3);
    smt.setString(4, str4);
    smt.setString(5, str5);
    smt.setString(6, str6);
    smt.setString(7, str7);
    smt.setString(8, str8);
    smt.setString(10, str9);
	smt.setString(9, str10);
	
    int flag = smt.executeUpdate();
    
    if(flag>0)
    {
        response.sendRedirect("./admin_dashboard.jsp");
    }
    con.close();
    }catch(Exception e)
    {
       out.println(e);
	   
    }

%>