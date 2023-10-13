<%@page import= "java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="checkLogin.jsp" %>

<script>
  function reloadPage() {
    // Set the cookie to indicate page reload
    document.cookie = 'pageReloaded=true';
    
    // Reload the page
    window.location.reload();
  }

  // Reload the page on every visit or back navigation
  window.addEventListener('pageshow', function(event) {
    // Check if the page was cached (navigated back)
    if (event.persisted || (!document.cookie.includes('pageReloaded=true'))) {
      reloadPage();
    }
  });
</script>

<%
    String id = request.getParameter("userid");

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
    } catch (Exception e) {
        out.println(e);
    }
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="../css/styles.css">
</head>

<body>

    <div class="container" style="max-width: fit-content;">
        <h1>Admin Dashboard</h1>
    </div>

    <div class="side-navbar" style="margin-left: 50px">
        <a href="./Logout.jsp" class="nav-button">Logout</a>
        <a href="../edit_details.html" class="nav-button">Edit Details</a>
    </div>

    <div class="card-container" style="max-width: fit-content; justify-content: center;">
        <%
        try {
            connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "root");
            statement = connection.createStatement();

            String sql = "select * from ngos where ngoId = " + session.getAttribute("loggedInUser");
            resultSet = statement.executeQuery(sql);

            while (resultSet.next()) {
        %>
        <div class="login-wrap p-4 p-md-5" style="margin-left: 165px;">
            
            <div class="icon d-flex align-items-center justify-content-center" >
            <span class="fa fa-user-o"></span>
            </div>

            <div class="login-form">
                <h2><%= resultSet.getString("ngoName") %></h2>
                <p>NGO ID: <%= resultSet.getString("ngoId") %></p>
                <p>Address: <%= resultSet.getString("addl1") %>, <%= resultSet.getString("addl2") %></p>
                <p>City: <%= resultSet.getString("city") %></p>
                <p>State: <%= resultSet.getString("state") %></p>
                <p>ZIP Code: <%= resultSet.getString("zipcode") %></p>
                <p>Profile: <%= resultSet.getString("prof") %></p>
                <p>Location Link: <%= resultSet.getString("lurl") %></p>
            </div>
        </div>
        
        <%
            resultSet.close();
            connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
        
        <div class="login-wrap p-4 p-md-5" style="margin-left: 253px;">
            <div class="icon d-flex align-items-center justify-content-center">
                <span class="fa fa-users"></span>
            </div>

            <div class="login-form">
                <h2>User Details</h2>
                <table class="user-tabletable custom-table">
                    <thead>
                        <tr>
                            <th scope="col"><strong style="font-size: 20px">User ID</strong></th>
                            <th scope="col"><strong style="font-size: 20px">User Name</strong></th>
                            <th scope="col"><strong style="font-size: 20px">User Phone Number</strong></th>
                            <th scope="col"><strong style="font-size: 20px">Type of Donation</strong></th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "root");

                            String userSql = "SELECT userId, userName, userNumber, typeOfDonation FROM users where ngoId = "+session.getAttribute("loggedInUser");
                            PreparedStatement userStatement = connection.prepareStatement(userSql);

                            ResultSet userResultSet = userStatement.executeQuery();

                            // Check if there are any results before displaying
                            if (!userResultSet.next()) {
                                out.println("<tr><td colspan='4'>No user found.</td></tr>");
                            } else {
                                do {
                        %>
                            <tr scope="row">
                                <td><strong style="font-size: 20px"><%= userResultSet.getString("userId") %></strong></td>
                                <td><strong style="font-size: 20px"><%= userResultSet.getString("userName") %></strong></td>
                                <td><strong style="font-size: 20px"><%= userResultSet.getString("userNumber") %></strong></td>
                                <td><strong style="font-size: 20px"><%= userResultSet.getString("typeOfDonation") %></strong></td>
                            </tr>
                            <tr class="spacer"><td colspan="100"></td></tr>
                        <%
                                } while (userResultSet.next());

                                userResultSet.close();
                            }

                            userStatement.close();
                            connection.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>    
                    </tbody>
                </table>
            </div>
        </div>
        
    </div>
</body>
</html>
