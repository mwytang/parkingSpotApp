<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.System" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
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
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>
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
        <title>My Bookings</title>   
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
					    <li><a href="hostbooking.jsp">Make Booking</a></li>
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
    <center><h1>My Bookings</h1></center>
    <%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key bookingKey = KeyFactory.createKey("ParkingSpotApp", "group5");
    
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    long now = System.currentTimeMillis();
    String n = String.valueOf(now);
    Filter owner = new FilterPredicate("user", FilterOperator.EQUAL, user.getNickname());
    Filter notStarted = new FilterPredicate("start", FilterOperator.GREATER_THAN_OR_EQUAL, n);
    Filter filter = CompositeFilterOperator.and(owner, notStarted);
    Query query = new Query("ParkingSpotApp", bookingKey).setFilter(filter).addSort("start", Query.SortDirection.ASCENDING);
    List<Entity> bookings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
    pageContext.setAttribute("now", now);
    
    if (bookings.isEmpty()) {
        %>
        <center><h3>Empty</h3></center>
        <%
    } else {
        %>
        <table class="bookings">
        <tr>
        <th>Parking Spot ID</th>
        <th>Start Time</th>
        <th>End Time</th>
        <th>Cancel?</th>
        </tr>
        <%
        for (Entity booking : bookings) {
            SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM yyyy HH:mm");
            long st = Long.parseLong(booking.getProperty("start").toString(), 10);
            long e = Long.parseLong(booking.getProperty("end").toString(), 10);
            sdf.setTimeZone(TimeZone.getTimeZone("America/Vancouver"));
            String start = sdf.format(st);
            String end = sdf.format(e);
            pageContext.setAttribute("spotId", booking.getProperty("spotId"));
            pageContext.setAttribute("start", start);
            pageContext.setAttribute("end", end);
            pageContext.setAttribute("st", st);
            pageContext.setAttribute("e", e);
            pageContext.setAttribute("id", booking.getProperty("ID/Name"));
        %>
            <tr>
            <td>${fn:escapeXml(spotId)}</td>
            <td>${fn:escapeXml(start)}</td>
            <td>${fn:escapeXml(end)}</td>
            <td><button type="submit" onclick='cancelBooking("${fn:escapeXml(spotId)}", "${fn:escapeXml(st)}", "${fn:escapeXml(e)}");'>Cancel</button></td>
            </tr>
        <% } %>
        </table>
    <% } %>
     <%
    } else {
    %>
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