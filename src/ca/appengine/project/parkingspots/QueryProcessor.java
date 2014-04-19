package ca.appengine.project.parkingspots;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.CompositeFilterOperator;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class QueryProcessor extends HttpServlet {
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
                
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Key bookingKey = KeyFactory.createKey("ParkingSpotApp", user.getNickname());
        
        String start = req.getParameter("start");
        String end = req.getParameter("end");
        
        // Run an ancestor query to ensure we see the most up-to-date
        // view of the Greetings belonging to the selected Guestbook.

        Filter startFilter1 = new FilterPredicate("start", FilterOperator.GREATER_THAN_OR_EQUAL, start);
        Filter startFilter2 = new FilterPredicate("start", FilterOperator.LESS_THAN_OR_EQUAL, end);
        
        Filter endFilter1 = new FilterPredicate("end", FilterOperator.GREATER_THAN_OR_EQUAL, start);
        Filter endFilter2 = new FilterPredicate("end", FilterOperator.LESS_THAN_OR_EQUAL, end);
        
        Filter startFilter = CompositeFilterOperator.and(startFilter1, startFilter2);
        Filter endFilter = CompositeFilterOperator.and(endFilter1, endFilter2);
        
        Filter filter = CompositeFilterOperator.or(startFilter, endFilter);
        
        Query query = new Query("ParkingSpotApp", bookingKey).setFilter(filter);
        //query.addSort("date", Query.SortDirection.DESCENDING);
        
        List<Entity> bookings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
        
        String responseHTMLString = "";
        
        if (bookings.isEmpty()) {
        	System.out.println("has no messages");
        	//responseHTMLString = "<div>'" + guestbookName + "' has no message for you.</div>";
        } else {
        	 List<String> ids = new ArrayList<String>();
        	 for (Entity booking : bookings) {
        		 String spotId = booking.getProperty("spotId").toString();	    		 
        		 ids.add(spotId);
        	 }
        	String list = ids.toString();
        	responseHTMLString = list.substring(1, list.length() - 1).replace(", ", ";");
        }
       
        //resp.setContentType("text/html");
        //resp.setCharacterEncoding("UTF-8");
            
        // Test
        //String htmlString = "<div>" + responseHTMLString + "</div>";
        //resp.getWriter().println(htmlString);
        // Test
            
        resp.getWriter().println(responseHTMLString);        
	}    
}
