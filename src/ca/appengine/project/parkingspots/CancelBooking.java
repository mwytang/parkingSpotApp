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
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CancelBooking extends HttpServlet {
    //@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        // We have one entity group per Guestbook with all Greetings residing
        // in the same entity group as the Guestbook to which they belong.
        // This lets us run a transactional ancestor query to retrieve all
        // Greetings for a given Guestbook.  However, the write rate to each
        // Guestbook should be limited to ~1/second.
        
        String spotId = req.getParameter("spotId");
        String start = req.getParameter("start");
        String end = req.getParameter("end");
       
        Key entityKey = KeyFactory.createKey("ParkingSpotApp", "group5");
        Filter spotFilter = new FilterPredicate("spotId", FilterOperator.EQUAL, spotId);
        Filter startFilter = new FilterPredicate("start", FilterOperator.EQUAL, start);
        Filter endFilter = new FilterPredicate("end", FilterOperator.EQUAL, end);
        
        Filter filter = CompositeFilterOperator.and(spotFilter, startFilter, endFilter);
        Query query = new Query("ParkingSpotApp", entityKey).setFilter(filter);
                
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        List<Entity> booking = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
        
        if (booking.isEmpty()) {
        	
        } else {
        	for (Entity book : booking) {
        		datastore.delete(book.getKey());
        	}
        }
        //datastore.delete
        
        // Test
        //String htmlString = "<div>" + user + " " + markerID + " " + guestbookName + " " + postMsg + "</div>";      
        //System.out.println(htmlString);  
        //resp.setContentType("text/html");
        resp.getWriter().println("OK");
        // Test
        
        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}
