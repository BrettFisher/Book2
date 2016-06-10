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
    var location: CLLocation? // optional because you might not have a location (like in the desert)
    var updatingLocation = false
    var lastLocationError: NSError?
    
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
        
        startLocationManager()
        updateLabels()
    }
    
    // MARK: - OutOfBoxMethods
    
    override func viewDidLoad()
    {
        print("viewDidLoad ran")
        super.viewDidLoad()
        updateLabels()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - MyMethods
    
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
        }
    }
    
    func stopLocationManager()
    {
        if updatingLocation
        {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
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
            }
        }
        
        
    }

}

