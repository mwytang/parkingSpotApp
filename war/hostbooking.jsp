<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta charset="utf-8">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<!-- BootStrap -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<link type="text/css" rel="stylesheet" href="/stylesheets/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAnKGB1sVx-WYMoDqgSV-qWuq0n0Wd3r8E&amp;sensor=true"
	style=""></script>
<script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
<script>   
    		$(function() {
         		$( "#calendar" ).datepicker({ defaultDate: new Date()}); 
   			 }); 
		</script>
<title>Make Booking</title>
<script type="text/javascript">
    function initialize() {
   		
   		// Default value the lat/long
   		var textlat = document.getElementById('textlat');
   		var textlong = document.getElementById('textlong');
   		textlat.value  = "49.26";
    	textlong.value = "-123.11";
    	
    	// Create a basic map on defaults		
    	var mapOptions = {
    		zoom: 14
  		};
  		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
   		
   		// Attempt to change map according to the client's coordinates
      	if (navigator.geolocation) {
   			navigator.geolocation.getCurrentPosition(function(position) {
     			textlat.value  = position.coords.latitude;
    			textlong.value = position.coords.longitude;
    			var initialLocation = new google.maps.LatLng ( textlat.value, textlong.value );
				map.setCenter(initialLocation); // It seems this function is parallel to the rest of the execution, so this update is necessary
       		});
    	}
    	    	
        // Get current state of lat/long
		var flat = textlat.value;
		var flong = textlong.value;
		var initialLocation = new google.maps.LatLng ( textlat.value, textlong.value );
		
		// Center the map
		map.setCenter(initialLocation);
           	
        //var mapOptions = {
        //   center: new google.maps.LatLng(flat, flong),
        //   zoom: 14
        //};
       
        // map = new google.maps.Map(document.getElementById("map-canvas"),
        //     mapOptions);
      	
      	/* Note: moved 'Here' marker to main.js
        var here = {
            map: map,
            position: new google.maps.LatLng(flat, flong),
            content: 'Here'
        }
        var infowindow = new google.maps.InfoWindow(here);
        map.setCenter(here.position);
        */
        
        
        google.maps.event.addListener(map, 'click', function(event) {
            placeMarker(event.latLng);
        });
        
        // Places marker where you click
        /*function placeMarker(location) {
            var marker = new google.maps.Marker({
                position: location, 
                map: map,
                draggable:true,
                title:"Drag me to your parking spot",
               
            });
            var latitude = latLng.lat();
            var longitude = latLng.lng();
            var addressText = document.getElementById("address");
            addressText.value = latitude + "," + longitude;              
        }*/
        
        //loadMarkers();        
    }
    google.maps.event.addDomListener(window, 'load', initialize);
    var today = new Date();
    var month = today.getMonth() + 1;
</script>

</head>
<body>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
	%>
	<nav class="navbar navbar-default" role="navigation">
		<div class="container-fluid">
			<div class="collapse navbar-collapse"
				id="bs-example-navbar-collapse-1">
				<a class="navbar-brand" href="index.jsp">ParkingSpots</a>
				<%
					if (user != null) {
				%>
				<ul class="nav navbar-nav">
					<li><a href="mybookings.jsp">My Bookings</a></li>
					<li><a href="hostbooking.jsp">Make Booking</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a
						href="<%=userService.createLogoutURL(request.getRequestURI())%>">
							Sign Out </a></li>
				</ul>
				<%
					}
				%>
			</div>
			<!-- /.navbar-collapse -->
		</div>
	</nav>
	<%
		if (user != null) {
			pageContext.setAttribute("user", user);
	%>
	<!-- put map and make appointment form here -->
	<center><h1>Create a Booking</h1></center>
	<p>
		Booking date: <input type="text" id="calendar" />
	</p>
	<p>
		Start time: <select id="startHour" name="hours">
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
		</select> : <select id="startMinute" name="minutes">
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
		</select> <select id="startampm" name="ampm">
			<option value="am">AM</option>
			<option value="pm">PM</option>
		</select>
	</p>
	<p>
		End time: <select id="endHour" name="hours">
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
		</select> : <select id="endMinute" name="minutes">
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
		</select> <select id="endampm" name="ampm">
			<option value="am">AM</option>
			<option value="pm">PM</option>
		</select>
	<p>

		Latitude: <input type="text" name="textlat" id="textlat" />
		Longitude: <input type="text" name="textlong" id="textlong" />
		
	</p>
		<button type="submit" onclick="getAjaxRequest();">Show Available
			Spots</button>
	<P>
		<!--Address: <INPUT TYPE="TEXT" NAME="address">-->
	</p>
	<script>
			//displays spots on map
			
		</script>
	<div id="map-canvas"></div>
	<%
		} else {
	%>
	<table class="login">
		<tr>
			<td>Please <a
				href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
					in</a>
			</td>
		</tr>
	</table>
	<%
		}
	%>
</body>
</html>