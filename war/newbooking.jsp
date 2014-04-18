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
        <script type="text/javascript" src="javascripts/main.js"></script> 
        <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
        <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAnKGB1sVx-WYMoDqgSV-qWuq0n0Wd3r8E&amp;sensor=true" style=""></script>
        <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
		<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?libraries=drawing&sensor=true"></script>
		<script>   
    		$(function() {
         		$( "#calendar" ).datepicker();   
   			 }); 
		</script>
        <title>New Booking</title>
        <script type="text/javascript">
            function initialize() {
                var mapOptions = {
                  center: new google.maps.LatLng(49.26123, -123.11393),
                  zoom: 15
                };
                map = new google.maps.Map(document.getElementById("map-canvas"),
                    mapOptions);
                var here = {
                    map: map,
                    position: new google.maps.LatLng(49.26123, -123.11393),
                    content: 'You are here'
                }
                var infowindow = new google.maps.InfoWindow(here);
                map.setCenter(here.position);
                
                var drawingManager = new google.maps.drawing.DrawingManager({
                	  drawingMode: google.maps.drawing.OverlayType.MARKER,
                	  drawingControl: true,
                	  drawingControlOptions: {
                	    position: google.maps.ControlPosition.TOP_CENTER,
                	    drawingModes: [
                	      google.maps.drawing.OverlayType.MARKER,,
                	      google.maps.drawing.OverlayType.RECTANGLE
                	    ]
                	  },
                	  markerOptions: {
                	    icon: 'http://www.example.com/icon.png'
                	  }
                	});
                	drawingManager.setMap(map);
                
                loadMarkers();  
            }
            google.maps.event.addDomListener(window, 'load', initialize);
        </script> 
 
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
                        <li><a href="hostbooking.jsp">Host Booking</a></li>
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
        <p>Booking date: <input type="text" id="calendar" /></p>
        <p> Start time: 
		<select name="hours">
		<option value="12">12</option>
		<option value="1">1</option>
		<option value="2">2</option>
		<option value="3">3</option>
		<option value="4">4</option>
		<option value="5">5</option>
		<option value="6">6</option>
		<option value="7">7</option>
		<option value="8">8</option>
		<option value="9">9</option>
		<option value="10">10</option>
		<option value="11">11</option>
		</select>
		:
		<select name="minutes">
		<option value="00">00</option>
		<option value="05">05</option>
		<option value="10">10</option>
		<option value="15">15</option>
		<option value="20">20</option>
		<option value="25">25</option>
		<option value="30">30</option>
		<option value="35">35</option>
		<option value="40">40</option>
		<option value="45">45</option>
		<option value="50">50</option>
		<option value="55">55</option>
		</select>
		<select name="ampm">
		<option value="am">AM</option>
		<option value="pm">PM</option>
		</select>
		</p>
		<p>
		 End time: 
		<select name="hours">
		<option value="12">12</option>
		<option value="1">1</option>
		<option value="2">2</option>
		<option value="3">3</option>
		<option value="4">4</option>
		<option value="5">5</option>
		<option value="6">6</option>
		<option value="7">7</option>
		<option value="8">8</option>
		<option value="9">9</option>
		<option value="10">10</option>
		<option value="11">11</option>
		</select>
		:
		<select name="minutes">
		<option value="00">00</option>
		<option value="05">05</option>
		<option value="10">10</option>
		<option value="15">15</option>
		<option value="20">20</option>
		<option value="25">25</option>
		<option value="30">30</option>
		<option value="35">35</option>
		<option value="40">40</option>
		<option value="45">45</option>
		<option value="50">50</option>
		<option value="55">55</option>
		</select>
		<select name="ampm">
		<option value="am">AM</option>
		<option value="pm">PM</option>
		</select>
		<button type="submit" onclick="displaySpots()">Show Available Spots</button>
		</p>
        <div id="map-canvas"></div>
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