<%@page import="java.sql.*,java.util.*"%>
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

<!DOCTYPE html>
<html lang="en">
<link href="https://fonts.googleapis.com/css?family=Lato:300,400,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="../css/styles.css">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Logged Out</title>
<link href='https://fonts.googleapis.com/css?family=Lato:300,400|Montserrat:700' rel='stylesheet' type='text/css'>
	<style>
		@import url(//cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css);
		@import url(//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css);
	</style>
	<link rel="stylesheet" href="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/default_thank_you.css">
	<script src="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/jquery-1.9.1.min.js"></script>
	<script src="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/html5shiv.js"></script>
</head>
<body>

    <header class="site-header" id="header">
	<h1 class="site-header__title" data-lead-id="site-header-title">THANK YOU!</h1>
	</header>

	<div class="main-content">
		<i class="fa fa-check main-content__checkmark" id="checkmark"></i>
		<p class="main-content__body" data-lead-id="main-content-body">Thanks a bunch for working with us. It means a lot to us, just like you do! We really appreciate you giving us a moment of your time today. Thanks for being you.</p>
	</div>

    <div class="button">
        <button style="color:aliceblue" onclick="window.location.href='../index.html'">HOME</button>
    </div>
<script>
    // Clear cookies
    var cookies = document.cookie.split(";");
    for (var i = 0; i < cookies.length; i++) {
        var cookie = cookies[i];
        var eqPos = cookie.indexOf("=");
        var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
        document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/";
    }
    // Redirect to the login page
</script>
</body>
</html>

<%
try{

    String authorisationId = request.getParameter("authorisationId");
    session.putValue("authorisationId", authorisationId);
    String pass = request.getParameter("pass");

    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "root");

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("select * from ngos where ngoid='" + authorisationId + "' and pass='" + pass + "'");

    rs.next();
    if (rs.getString("pass").equals(pass) && rs.getString("ngoid").equals(authorisationId)) {
        
        st.executeUpdate("delete from ngos where ngoid='" + authorisationId + "' and pass='" + pass + "'");
    
    } else {
        out.println("Invalid password or username.");
    }
    rs.close();
    con.close();

}catch (Exception e){
    out.println(e);
}

%>