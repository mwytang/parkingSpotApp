var map;
var xmlHttpReq = null;
var selectedMarkerID;
var guestbookNameString = "";
var cityCircle;
var badIds;
var index;

var hourLookup = {};
hourLookup["12AM"] = "0";
hourLookup["1AM"] = "1";
hourLookup["2AM"] = "2";
hourLookup["3AM"] = "3";
hourLookup["4AM"] = "4";
hourLookup["5AM"] = "5";
hourLookup["6AM"] = "6";
hourLookup["7AM"] = "7";
hourLookup["8AM"] = "8";
hourLookup["9AM"] = "9";
hourLookup["10AM"] = "10";
hourLookup["11AM"] = "11";
hourLookup["12PM"] = "12";
hourLookup["1PM"] = "13";
hourLookup["2PM"] = "14";
hourLookup["3PM"] = "15";
hourLookup["4PM"] = "16";
hourLookup["5PM"] = "17";
hourLookup["6PM"] = "18";
hourLookup["7PM"] = "19";
hourLookup["8PM"] = "20";
hourLookup["9PM"] = "21";
hourLookup["10PM"] = "22";
hourLookup["11PM"] = "23";

function loadMarkers() {
	//alert("loadMarkers");
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_loadMarkers;
		var url = "/resources/spots.xml";
	
		xmlHttpReq.open('GET', url, true);
    	xmlHttpReq.send(null);
    	
    	//alert();
    	
	} catch (e) {
    	alert("Error: " + e);
	}	
}

function httpCallBackFunction_loadMarkers() {
	//alert("httpCallBackFunction_loadMarkers");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");			 	
		}

		if(xmlDoc){				
			//alert(xmlHttpReq.responseText);	
						
			var markerElements = xmlDoc.getElementsByTagName('marker');
			//alert(markerElements[0].getAttribute("srl"));	
			//alert(markerElements.length);
			var date = document.getElementById("calendar").value;
			
			var startHour = document.getElementById("startHour");
			startHour = startHour.options[startHour.selectedIndex].text;
			var startMinute = document.getElementById("startMinute");
			startMinute = startMinute.options[startMinute.selectedIndex].text;
			var startampm = document.getElementById("startampm");
			startampm = startampm.options[startampm.selectedIndex].text;
			startHour = hourLookup[startHour+startampm]
			
			var endHour = document.getElementById("endHour");
			endHour = endHour.options[endHour.selectedIndex].text;
			var endMinute = document.getElementById("endMinute");
			endMinute = endMinute.options[endMinute.selectedIndex].text;
			var endampm = document.getElementById("endampm");
			endampm = endampm.options[endampm.selectedIndex].text;
			endHour = hourLookup[endHour+endampm]
			
			date = date.split("/");
			var month = parseInt(date[0]) - 1;
			var day = parseInt(date[1]);
			var year = date[2];
			
			var starttime = +new Date(year, month, day, startHour, startMinute);
			var endtime = +new Date(year, month, day, endHour, endMinute);
			
			badIds = badIds.replace(/(\r\n|\n|\r)/gm,"");
			badIds = badIds.split(";");
			
			for(mE = 0; mE < markerElements.length; mE++) {
				var markerElement = markerElements[mE];
				
				//alert(markerElement.getAttribute("srl"));
				
				var lat = parseFloat(markerElement.getAttribute("lat"));
				var lng = parseFloat(markerElement.getAttribute("lng"));
				var srl = markerElement.getAttribute("srl");
							
				var myLatlng = new google.maps.LatLng(lat, lng);
								
				var mrkID = ""+srl;
				
				var contentString  = 'Spot #' + mrkID + '<div id="content"><div class="box">' +
					'<input type="button" value="Book" onclick="postAjaxRequest('+ 
					"'" + mrkID + "', '" + starttime + "', '" + endtime + "')" + '"/>' +
					'</div></div>';
				
				index = badIds.indexOf(mrkID);
				if (index == -1) {										
					var marker = new google.maps.Marker({       
						position: myLatlng,
						map: map,
						title: ''+mrkID
					});
				
					addInfowindow(marker, contentString);
				}
			}
			console.log(badIds);
		}else{
			alert("No data.");
		}	
	}		
}

function addInfowindow(marker, content) {
	var infowindow = new google.maps.InfoWindow({
			content: content
	});
	//alert('content');
	google.maps.event.addListener(marker, 'click', function() {
		selectedMarkerID = marker.getTitle();
		infowindow.setContent(""+content);
		infowindow.setPosition(marker.getPosition());
		infowindow.open(marker.get('map'), marker);		 
		//getAjaxRequest(); 
	});
}

function getAjaxRequest() {
	//alert("getAjaxRequest");
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_getAjaxRequest;

		var date = document.getElementById("calendar").value;

		if (date == "") {
			alert('Please select a date.');
			return false;
		}
		
		var startHour = document.getElementById("startHour");
		startHour = startHour.options[startHour.selectedIndex].text;
		var startMinute = document.getElementById("startMinute");
		startMinute = startMinute.options[startMinute.selectedIndex].text;
		var startampm = document.getElementById("startampm");
		startampm = startampm.options[startampm.selectedIndex].text;
		startHour = hourLookup[startHour+startampm]
		
		var endHour = document.getElementById("endHour");
		endHour = endHour.options[endHour.selectedIndex].text;
		var endMinute = document.getElementById("endMinute");
		endMinute = endMinute.options[endMinute.selectedIndex].text;
		var endampm = document.getElementById("endampm");
		endampm = endampm.options[endampm.selectedIndex].text;
		endHour = hourLookup[endHour+endampm]
		
		date = date.split("/");
		var month = parseInt(date[0]) - 1;
		var day = parseInt(date[1]);
		var year = date[2];
		
		var starttime = +new Date(year, month, day, startHour, startMinute);
		var endtime = +new Date(year, month, day, endHour, endMinute);
		var now = +new Date();
		
		if (endtime <= starttime) {
			alert('End time has to be later than Start time.');
			return false;
		} else if (starttime < now) {
			alert('Start time has already past.');
			return false;
		} else if (endtime < now) {
			alert('End time has already past.');
			return false;
		}

		displaySpots();
		var url = "/queryprocessor?start="+starttime+"&end="+endtime;
		
		xmlHttpReq.open('GET', url, true);
    	xmlHttpReq.send(null);
    	
    	//alert();
    	
	} catch (e) {
    	alert("Error: " + e);
	}	
}

function httpCallBackFunction_getAjaxRequest() {
	//alert("httpCallBackFunction_getAjaxRequest");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");
		}

		if(xmlDoc){				
			//alert(xmlHttpReq.responseText);
			badIds = xmlHttpReq.responseText;
			loadMarkers();
			//document.getElementById("msglist_"+selectedMarkerID).innerHTML=xmlHttpReq.responseText;					
		}else{
			alert("No data.");
		}	
	}		
}

function postAjaxRequest(spotId, start, end) {
	//alert("postAjaxRequest");
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_postAjaxRequest;
		var url = "/booking";
	
		xmlHttpReq.open("POST", url, true);
		xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
		
		/*var postMsgValue = document.getElementById(postMsg).value;
		var markerIDValue = markerID; 
		var guestbookNameValue = guestbookName;*/ 
    	
		xmlHttpReq.send("spotId="+spotId+"&start="+start+"&end="+end);
    	
    	//alert();
    	
	} catch (e) {
    	alert("Error: " + e);
	}	
}

function httpCallBackFunction_postAjaxRequest() {
	//alert("httpCallBackFunction_postAjaxRequest");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");		 		
		}
		
		window.location.replace("/mybookings.jsp");
		if(xmlDoc){				
			//alert(xmlHttpReq.responseText);			
			//document.getElementById("msglist_"+selectedMarkerID).innerHTML=xmlHttpReq.responseText;
			//document.getElementById("msgbox_"+selectedMarkerID).value = "";
			//alert('Booking Made');
		}else{
			alert("No data.");
		}	
	}		
}

function cancelBooking(spotId, start, end) {
	var confirmation = confirm("Are you sure?");
	if (confirmation) {
		try {
			xmlHttpReq = new XMLHttpRequest();
			xmlHttpReq.onreadystatechange = httpCallBackFunction_cancelBooking;
			var url = "/cancel";
		
			xmlHttpReq.open("POST", url, true);
			xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
	    	
			xmlHttpReq.send("spotId="+spotId+"&start="+start+"&end="+end);
	    	
	    	//alert();
	    	
		} catch (e) {
	    	alert("Error: " + e);
		}
	} else {
		return false;
	}
}

function httpCallBackFunction_cancelBooking() {
	//alert("httpCallBackFunction_postAjaxRequest");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");		 		
		}
		
		if(xmlDoc){				
			//alert(xmlHttpReq.responseText);			
			//document.getElementById("msglist_"+selectedMarkerID).innerHTML=xmlHttpReq.responseText;
			//document.getElementById("msgbox_"+selectedMarkerID).value = "";
			window.location.replace("/mybookings.jsp");
		}else{
			alert("No data.");
		}	
	}		
}

//displays spots on map
function displaySpots()
{
	var locations = {};
	locations['location1'] = {
		center: new google.maps.LatLng(49.26123, -123.11393)
	};
	 // Construct the circle for each value in locations.

	for (var location in locations) {
		var circleOptions = {
			strokeColor: '#FF0000',
			strokeOpacity: 0.8,
			strokeWeight: 2,
			fillColor: '#FF0000',
			fillOpacity: 0.35,
			map: map,
			center: locations[location].center,
			radius: 1000
		};
		//remove previous circle
		if (typeof cityCircle !== 'undefined') {
			cityCircle.setMap(null);
		}
		// Add the circle for this city to the map.
		cityCircle = new google.maps.Circle(circleOptions);
    }
    
}