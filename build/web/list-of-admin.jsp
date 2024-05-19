<%@page import="DAO.LoginDAO"%>
<%@page import="DAO.AdminDAO"%>
<%@page import="util.connectDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String adminID = (String)session.getAttribute("session_adminID");
    String adminrole = (String)session.getAttribute("session_adminRole");
    String adminName = null; // Variable to store the adminName
    String adminStatuss = null; // Variable to store the adminStatus
    int adminStatusID = 0;
    
    if (adminID == null && adminrole == null) { // if null (user not logged in), redirect to login page
        request.setAttribute("msgs", "You have not logged in");
        out.println("<script> location.href='./index.jsp'; </script>");
    } else {
        // Retrieve the adminName and adminStatus from the database
        try {
            Connection conn = connectDB.createConnection();
            
            // Query to retrieve adminName
            String nameQuery = LoginDAO.NAME_QUERY;
            
            // Query to retrieve adminStatus
            String statusQuery = LoginDAO.STATUS_QUERY;
            
            // Prepare the statements
            PreparedStatement nameStmt = conn.prepareStatement(nameQuery);
            PreparedStatement statusStmt = conn.prepareStatement(statusQuery);
            
            // Set the parameter for adminID in both queries
            nameStmt.setString(1, adminID);
            statusStmt.setString(1, adminID);
            
            // Execute the queries
            ResultSet nameRs = nameStmt.executeQuery();
            ResultSet statusRs = statusStmt.executeQuery();
            
            // Retrieve the adminName
            if (nameRs.next()) {
                adminName = nameRs.getString("EMPLOYEE_NAME");
            }
            
            // Retrieve the adminStatus
            if (statusRs.next()) {
                adminStatuss = statusRs.getString("ADMINISTRATORSTATUS_NAME");
                adminStatusID = statusRs.getInt("ADMINISTRATORSTATUS_ID");
            }
            
            // Close the result sets and statements
            nameRs.close();
            statusRs.close();
            nameStmt.close();
            statusStmt.close();
            
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%
    //establish a connection to database
    Connection conn = connectDB.createConnection();
    Statement stmt = conn.createStatement(); //create the statement   
    
    String sqlemp = AdminDAO.ADMIN_QUERY;
       
    ResultSet rsemp = stmt.executeQuery(sqlemp); 

%>



<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>List of Administrators</title>
        <meta name="description" content="EMPLOYEE REWARD MANAGEMENT SYSTEM">
        <meta name="keywords" content="EMPLOYEE REWARD MANAGEMENT SYSTEM">
        <meta name="author" content="Orion">
         <!-- Favicons -->
        <link href="assets/img/ORION_Logo.png" rel="icon">
        <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

        <!-- Google Fonts -->
        <link href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

        <!-- Vendor CSS Files -->
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
        <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
        <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
        <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

        <!-- Template Main CSS File -->
        <link href="assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.css" />
        
        <style>
            .my-button {
              width: 120px;
              height: 30px;
              margin-left: 13px;
            }
        </style>
    </head>
    <body>
        
                <!-- ======= Header ======= -->
        <header id="header" class="header fixed-top d-flex align-items-center">
          <i class="bi bi-list toggle-sidebar-btn"></i>

          <nav class="header-nav ms-auto">
            <ul class="d-flex align-items-center">

                    <li class="nav-item dropdown pe-3">
        <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
          <img src="assets/img/user-profile-icon-free-vector.jpg" alt="Profile" class="rounded-circle">
          <span class="d-none d-md-block dropdown-toggle ps-2"><%= adminName %></span>
        </a><!-- End Profile Image Icon -->

        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
          <li class="dropdown-header">
            <div style="text-align: left;">
            <h6>ID: <%= adminID %></h6>
            <h6>Name:</h6>
            <span><%= adminName %></span><br>
            <h6>Role:</h6>
            <% 
              if (adminrole.equals("MANAGER")) {
                %><span>Manager</span><%
              } else {
                %><span>Moderator</span><%
              }
            %>
            <h6>Status:</h6>
            <span><%= adminStatuss %></span>
            </div>
          </li>
          <li>
            <hr class="dropdown-divider">
          </li>
          <li>
            <a class="dropdown-item d-flex align-items-center" href="./LogoutServlet">
              <i class="bi bi-box-arrow-right"></i>
              <span>Sign Out</span>
            </a>
          </li>
        </ul><!-- End Profile Dropdown Items -->
              </li><!-- End Profile Nav -->

            </ul>
          </nav><!-- End Icons Navigation -->

        </header><!-- End Header -->
        
        
        <% if(adminrole.equals("MANAGER")){%>
         <jsp:include page="src/sidebar/sidebar-manager.jspf"/>        
        <% } else { %>
        <jsp:include page="src/sidebar/sidebar-moderator.jspf"/>  
        <% } %>
        
        
   <main id="main" class="main">
    <div class="pagetitle">
<!--      <h1>Dashboard</h1>-->

    </div><!-- End Page Title -->

    <section class="section dashboard">
    <div class="row">
	<h1>List of Administrators</h1>
        <button class="my-button"><a href="administrator-add.jsp" style="color: black;">Add Admin</a></button><br><br>
       
       <table id="myTable" class="display">
  <thead>
    <tr>
      <th>#</th>
      <th>Admin ID</th>
      <th>Admin Name</th>
      <th>Admin Status</th>
      <th>Change Status</th>
    </tr>
  </thead>
  <tbody>
    <% 
    //Iterate over the ResultSet
    int number = 1;
    while (rsemp.next()) { 
      String adminStatus = rsemp.getString("administratorstatus_name");
      String statusButtonLabel = adminStatus.equals("Active") ? "Deactivate" : "Activate";
    %>
    <tr>
      <td><%= number %></td>
      <td><%= rsemp.getInt("administrator_id") %></td>
      <td><%= rsemp.getString("employee_name") %></td>
      <td><%= rsemp.getString("administratorstatus_name") %></td>
      <td>
        <form method="post" action="<%= adminStatus.equals("Active") ? "DeactivateAdminServlet" : "ActivateAdminServlet" %>">
        <input type="hidden" name="adminID" value="<%= rsemp.getInt("administrator_id") %>">
        <input type="hidden" name="adminStatusID" value="<%= adminStatusID %>">
        <% if (rsemp.getInt("administrator_id") == Integer.parseInt(adminID)) { %>
          <button disabled type="submit" class="btn btn btn-outline-danger evaluate-button"><%= statusButtonLabel %></button>
<!--          <button class="btn btn-outline-danger" disabled>Evaluate</button>-->
        <% } else { %>
          <button type="submit" class="btn btn-outline evaluate-button"><%= statusButtonLabel %></button>
        <% } %>
      </form>
      </td>
    </tr>
    <% 
      number++;
    } 
    %>
  </tbody>
</table>           
                
      </div>
    </section>
                
                

  </main><!-- End #main -->

<span style="color:red;text-align:center">
  <% String message = (String) request.getAttribute("msgs");
    if (message != null && !message.isEmpty()) { %>
      <script>alert('<%= message %>');</script>
  <% } %>
</span>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets/vendor/chart.js/chart.umd.js"></script>
  <script src="assets/vendor/echarts/echarts.min.js"></script>
  <script src="assets/vendor/quill/quill.min.js"></script>
  <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
  <script src="assets/vendor/tinymce/tinymce.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>

  <!-- Template Main JS File -->
  <script src="assets/js/main.js"></script>
  <script src="assets/js/jquery-3.7.0.js"></script>
  <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.print.min.js"></script>
  <script>
	$(document).ready( function () {
    	$('#myTable').DataTable( {
            dom:'Bfrtip',
            buttons: [
                'print'
            ]
        });
	} );
        
  </script>
    <%     
        // Process the result set
        rsemp.close();
        stmt.close();
        conn.close();
    %>
    </body>
</html>