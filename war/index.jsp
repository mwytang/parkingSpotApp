<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" /> 
        <meta charset="utf-8">       
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <!-- BootStrap -->
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
        <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="/javascripts/main.js"></script> 
        <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
        <title>ParkingSpots</title>   
    </head>
    <body>
    <%
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
    %>
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <a class="navbar-brand" href="index.jsp">ParkingSpots</a>
                <% if (user != null) { %>
                    <ul class="nav navbar-nav">
                        <li><a href="mybookings.jsp">My Bookings</a></li>
                        <li><a href="newbooking.jsp">New Booking</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
                        Sign Out
                        </a></li>
                    </ul>
                <% } %>
            </div><!-- /.navbar-collapse -->
        </div>
    </nav>
    <%
    if (user != null) {
        pageContext.setAttribute("user", user);
    %>
        <!-- put map and make appointment form here -->
        <!-- <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
            <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)
        </p> -->
        may want to merge newbookings with index
     <%
    } else {
    %>
        <!--<p>Hello!
            <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
            to include your name with greetings you post.
        </p>-->
        <table class="login">
            <tr>
                <td>Please 
                <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
                </td>
            </tr>
        </table>
    <%
    }
    %>
    </body>
</html>