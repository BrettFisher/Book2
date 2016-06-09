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
    
    @IBAction func getLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // if the location fails to update, this delegate method will tell us why
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("didFailWithError \(error)")
    }
    
    // shows the last updated location that CLLocation receieved
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
    }

}

