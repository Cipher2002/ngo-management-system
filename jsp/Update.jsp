<%@ page import="org.apache.commons.*"%>
<%@ page import="java.sql.*,java.util.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ include file="checkLogin.jsp" %>

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
  try {
    String str6 = request.getParameter("zip");
    String str1 = request.getParameter("ngoName");
    String str2 = request.getParameter("address1");
    String str3 = request.getParameter("address2");
    String str4 = request.getParameter("city");
    String str5 = request.getParameter("state");
    String str7 = request.getParameter("summary");
    String str8 = request.getParameter("mapsLink");
    String pass = request.getParameter("pass");
    
    out.println("Debug: User ID: " + (String) session.getAttribute("loggedInUser"));
    out.println("Debug: Password: " + pass);

    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "root");

    String str = "select * from ngos where ngoId=? and pass=?";
    PreparedStatement smt = con.prepareStatement(str);
    smt.setString(1, (String) session.getAttribute("loggedInUser"));
    smt.setString(2, (String) session.getAttribute("loggedInPassword"));
    ResultSet rs = smt.executeQuery();
    
    out.println("Debug: Query executed.");

    if (rs.next()) {
      out.println("Debug: Valid username and password.");

      String strUpdate = "update ngos set ngoname=?, addl1=?, addl2=?, city=?, state=?, zipcode=?, prof=?, lurl=?, pass=? where ngoId=? and pass=?";
      PreparedStatement smtUpdate = con.prepareStatement(strUpdate);

      smtUpdate.setString(1, str1);
      smtUpdate.setString(2, str2);
      smtUpdate.setString(3, str3);
      smtUpdate.setString(4, str4);
      smtUpdate.setString(5, str5);
      smtUpdate.setString(6, str6);
      smtUpdate.setString(7, str7);
      smtUpdate.setString(8, str8);
      smtUpdate.setString(9, pass);
      smtUpdate.setString(10, (String) session.getAttribute("loggedInUser"));
      smtUpdate.setString(11, (String) session.getAttribute("loggedInPassword"));

      int flag = smtUpdate.executeUpdate();
      if (flag > 0) {
        out.println("Debug: Data updated successfully.");
        response.sendRedirect("./admin_dashboard.jsp");
      } else {
        out.println("Debug: Failed to update data.");
      }
    } else {
      out.println("Debug: Invalid password or username.");
    }

    rs.close();
    smt.close();
    con.close();
  } catch (Exception e) {
    out.println("Debug: An error occurred: " + e.getMessage());
    e.printStackTrace();
  }
%>
