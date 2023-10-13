<%
    // Perform logout actions if needed (e.g., invalidate session)
    session.invalidate();
    response.sendRedirect("../index.html");
%>

