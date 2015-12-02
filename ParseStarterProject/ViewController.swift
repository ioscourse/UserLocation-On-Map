/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/
import Foundation
import UIKit
import Parse
import CoreLocation
import MapKit

class ViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{
    var timer:NSTimer?
    var blnCenter:Bool = false
var mapuser:NSMutableArray = []
var maplong:NSMutableArray = []
var maplat:NSMutableArray = []
var locationManager = CLLocationManager()
    @IBOutlet weak var txtfullnamde: UILabel!
   
    @IBOutlet weak var btnProfiles: UIBarButtonItem!
    
    @IBAction func btnProfiles(sender: AnyObject) {
        timer?.invalidate()
    }
    
    @IBOutlet weak var labellocation: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidAppear(animated: Bool) {
        un = ""
       // map.showsUserLocation = true
         blnCenter = false
         map.showsUserLocation = true
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userNameNotNull = defaults.objectForKey("fullname") as? String {
            self.txtfullnamde.text = defaults.objectForKey("fullname") as? String
            un = self.txtfullnamde.text
        }
        
        
        let query = PFQuery(className:"MapLocation")
        query.whereKey("fullname", equalTo: txtfullnamde.text!)
        query.findObjectsInBackgroundWithBlock { (object: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if object!.count > 0 {
                    if let object = object! as? [PFObject] {
                        for object in object {
                            self.txtfullnamde.text = (object["fullname"] as! String)
                        }
                    }
                }
                
                
            }
        }
        if self.txtfullnamde.text == "Enter FullName in Profile"
        {
            let alertController = UIAlertController(title: "Fullname Reguired", message:
                "Go to Profile", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
             timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "updatelocation", userInfo: nil, repeats: true)
        }
        
    }
    func updatelocation()
    {
         locationManager.requestLocation()
         mappoint()
    }
    
    func mappoint()
    {
        self.mapuser = NSMutableArray()
         self.maplong = NSMutableArray()
         self.maplat = NSMutableArray()
        let query = PFQuery(className:"MapLocation")
        query.findObjectsInBackgroundWithBlock { (object: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.map.removeAnnotations(self.map.annotations)
                for people in object! {
                    print(people["longitude"] as? String)
                    if people["longitude"] as? String != nil && people["longitude"] as? String != ""
                    {
                        let long:Double = Double((people["longitude"] as? String)!)!
                        let lat:Double = Double((people["latitude"] as? String)!)!
                        let TheirLocation = CLLocationCoordinate2DMake(lat, long)
                    // Drop a pin
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = TheirLocation
                    dropPin.title = people["fullname"] as? String
                    dropPin.subtitle = "Last Updated: \(people["lastupdate"] as! String)"
                    self.map.addAnnotation(dropPin)
                     
                        
                    }
                    
                }
                
                //iterate and create annotations
              
            }
        }

    }
  
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        map.centerCoordinate = userLocation.location!.coordinate
//        self.mappoint()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Core Location Manager asks for GPS location
        if (CLLocationManager.locationServicesEnabled())
        {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }        else{
            print("Location service disabled");
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        if blnCenter == false
        {
            blnCenter = true
             let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.map.setRegion(region, animated: true)
        }
        //self.locationManager.stopUpdatingLocation()
        labellocation.text = "MyGeoLocation: \(location!.coordinate.latitude),\(location!.coordinate.longitude)"
        let query = PFQuery(className:"MapLocation")
        query.whereKey("fullname", equalTo: txtfullnamde.text!)
        query.findObjectsInBackgroundWithBlock { (object: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for user in object! {
                    user["latitude"] = String(location!.coordinate.latitude)
                    user["longitude"] = String(location!.coordinate.longitude)
                    let deliveryTime = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
                    user["lastupdate"] = deliveryTime
                    //do this for any columns you want updated
                    user.saveInBackground() //to save the newly updated user
                    //self.mappoint()
                } 
                
            }
        }
       

    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}
