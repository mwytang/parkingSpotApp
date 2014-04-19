package ca.appengine.project.parkingspots;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MakeBookingServlet extends HttpServlet {
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
       
        Key userKey = KeyFactory.createKey("ParkingSpotApp", user.getNickname());
        //Date date = new Date();
        Entity booking = new Entity("ParkingSpotApp", userKey);
        
        booking.setProperty("user", user);
        booking.setProperty("spotId", spotId);
        booking.setProperty("start", start);
        booking.setProperty("end", end);
       
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(booking);	
        
        // Test
        //String htmlString = "<div>" + user + " " + markerID + " " + guestbookName + " " + postMsg + "</div>";      
        //System.out.println(htmlString);  
        //resp.setContentType("text/html");
        //resp.getWriter().println(htmlString);
        // Test
        
        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}
