<%@ page import="java.sql.*" %>

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
      String authorisationId = request.getParameter("authorisationId");
      
      String password = request.getParameter("pass");

      String query = "SELECT * FROM ngos WHERE ngoid = ? AND pass = ?";
      
      Class.forName("oracle.jdbc.driver.OracleDriver");
      Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "root");
      
      PreparedStatement preparedStatement = con.prepareStatement(query);
      preparedStatement.setString(1, authorisationId);
      preparedStatement.setString(2, password);

      ResultSet resultSet = preparedStatement.executeQuery();
      boolean userExists = resultSet.next();
      
      resultSet.close();
      preparedStatement.close();
      con.close();

      if (userExists) {
          // Redirect to dashboard on successful login
          session.setAttribute("loggedInUser", authorisationId);
          session.setAttribute("loggedInPassword", password);
          response.sendRedirect("./admin_dashboard.jsp");
      } else {
          // Display alert for error
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Login Error</title>
<link href="https://fonts.googleapis.com/css?family=Lato:300,400,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="./css/styles.css">
<script>
    alert("Incorrect NGO ID or Password. Please check your credentials and try again.");
    window.location.href = "../index.html"; // Redirect back to the login page
</script>
</head>
<body>
</body>
</html>
<%
      }
   } catch (Exception e) {
      e.printStackTrace();
      out.println(e);
   }
%>
