//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Fisher, Brett on 6/15/16.
//  Copyright © 2016 Fisher, Brett. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: NSDateFormatter =
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        print("I was only created just now.")
        return formatter
    }()

class LocationDetailsViewController: UITableViewController
{
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    // MARK: - Out of Box Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        descriptionTextView.text = ""
        categoryLabel.text = ""
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark
        {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = formatDate(NSDate())
    }
    
    // MARK: - My Methods
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String
    {
        var text = ""
        
        if let s = placemark.subThoroughfare
        {
            text += s + " "
        }
        if let s = placemark.thoroughfare
        {
            text += s + " "
        }
        if let s = placemark.locality
        {
            text += s + ", "
        }
        if let s = placemark.administrativeArea
        {
            text += s + " "
        }
        if let s = placemark.postalCode
        {
            text += s + ", "
        }
        if let s = placemark.country
        {
            text += s
        }
        return text
    }
    
    func formatDate(date: NSDate) -> String
    {
        return dateFormatter.stringFromDate(date)
    }
    
    // MARK: - Action Methods
    
    @IBAction func done()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}