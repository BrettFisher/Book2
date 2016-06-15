//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Fisher, Brett on 6/9/16.
//  Copyright © 2016 Fisher, Brett. All rights reserved.
//

import UIKit //so we can use the UIKit
import CoreLocation //so we can track our location

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate
{
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager() //the object that will give us our GPS coordinates
    let geocoder = CLGeocoder() // reverse geocoding object
    var location: CLLocation? // optional because you might not have a location (like in the desert)
    var updatingLocation = false
    var lastLocationError: NSError? // location error handler object
    var placemark: CLPlacemark? // object containing the address results
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError? //geocoding error handler object
    var timer: NSTimer?
    
    // MARK: - Action Methods
    
    @IBAction func getLocation()
    {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted
        {
            showLocationServicesDeniedAlert()
            return
        }
        
        if updatingLocation
        {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        
        updateLabels()
        configureGetButton()
    }
    
    // MARK: - Out of Box Methods
    
    override func viewDidLoad()
    {
        print("viewDidLoad ran")
        super.viewDidLoad()
        updateLabels()
        configureGetButton()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "TagLocation"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailsViewController
            controller.coordinate = location!.coordinate
            controller.placemark = placemark
        }
    }
    
    // MARK: - My Methods
    
    func showLocationServicesDeniedAlert()
    {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLabels()
    {
        if let location = location // if theres a location
        {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.hidden = false
            messageLabel.text = ""
            
            if let placemark = placemark
            {
                addressLabel.text = stringFromPlacemark(placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
            
        } else { // if there isn't a location
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.hidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
            
            let statusMessage: String
            if let error = lastLocationError
            {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue
                {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled()
            {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
    }
    
    func startLocationManager()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("didTimeOut"), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocationManager()
    {
        if updatingLocation
        {
            if let timer = timer
            {
                timer.invalidate()
            }
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func configureGetButton()
    {
        if updatingLocation
        {
            getButton.setTitle("Stop", forState: .Normal)
        } else {
            getButton.setTitle("Get My Location", forState: .Normal)
        }
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String
    {
        //1
        var line1 = ""
        
        //2
        if let s = placemark.subThoroughfare // house number
        {
            line1 += s + " "
        }
        
        //3
        if let s = placemark.thoroughfare // street name
        {
            line1 += s
        }
        
        //4
        var line2 = ""
        
        if let s = placemark.locality // city
        {
            line2 += s + ", "
        }
        if let s = placemark.administrativeArea // state or province
        {
            line2 += s + " "
        }
        if let s = placemark.postalCode // zip code
        {
            line2 += s
        }
        
        //5
        return line1 + "\n" + line2 // print whole address
    }
    
    func didTimeOut()
    {
        print("*** Time Out")
        
        if location == nil
        {
            stopLocationManager()
            
            lastLocationError = NSError(domain: "MyLOcationsErrorDomain", code: 1, userInfo: nil)
            
            updateLabels()
            configureGetButton()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // if the location fails to update, this delegate method will tell us why
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("didFailWithError \(error)")
        
        if error.code == CLError.LocationUnknown.rawValue // rawValue reports back the actual error code
        {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    // shows the last updated location that CLLocation receieved
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        //1 
        if newLocation.timestamp.timeIntervalSinceNow < -5
        {
            return
        }
        
        //2
        if newLocation.horizontalAccuracy < 0
        {
            return
        }
        
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location
        {
            distance = newLocation.distanceFromLocation(location)
        }
        
        //3
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy
        {
            //4
            lastLocationError = nil
            location = newLocation
            updateLabels()
            
            //5
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy
            {
                print("*** We're done!")
                stopLocationManager()
                configureGetButton()
                
                if distance > 0
                {
                    performingReverseGeocoding = false
                }
            }
            
            if !performingReverseGeocoding
            {
                print("*** Going to geocode")
                
                performingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(newLocation, completionHandler:
                    {placemarks, error in
                        print("*** Found placemarks: \(placemarks), error: \(error)")
                        self.lastGeocodingError = error
                        if error == nil, let p = placemarks where !p.isEmpty
                        {
                            self.placemark = p.last!
                        } else {
                            self.placemark = nil
                        }
                        
                        self.performingReverseGeocoding = false
                        self.updateLabels()
                    })
            } else if distance < 1.0 {
                let timeInterval = newLocation.timestamp.timeIntervalSinceDate(location!.timestamp)
                if timeInterval > 10
                {
                    print("*** Force done!")
                    stopLocationManager()
                    updateLabels()
                    configureGetButton()
                }
            }
            
        }
        
    }

}

