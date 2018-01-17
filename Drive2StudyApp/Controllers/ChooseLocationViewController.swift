//
//  ChooseLocationViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 28/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

// Popup style window for choose the location
class ChooseLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // for GPS location
    let locationManager = CLLocationManager()
    var location: String = ""
    
    @IBOutlet weak var LocationLabel: UITextField!
    var type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        let dr = DriveRide(userName: Model.studentCurrent.userName, fromWhere: LocationLabel.text!, type: self.type, imageUrl: Model.studentCurrent.imageUrl)
        
        // If the user wants to add his current location by gps
        if LocationLabel.text! == "" {
            latLngDecoder() { (location) in
                if (location != "") {
                    dr.fromWhere = location.replacingOccurrences(of: "\'", with: "")
                    DriveRideModel.addNewDriveRide(dr: dr)
                    self.dismiss(animated: true, completion: nil)
                } else { print("Error find localization by GPS") }
            }
        } else {    // if the user typed an address
            DriveRideModel.addNewDriveRide(dr: dr)
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    // callback function, perform reverse gecode to the current location coordinates and return the address
    func latLngDecoder(callback:@escaping (String)->Void) {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let longitude = self.locationManager.location?.coordinate.longitude
        let latitude = self.locationManager.location?.coordinate.latitude
        self.locationManager.stopUpdatingLocation()
        let location = CLLocation(latitude: latitude!, longitude: longitude!) //changed!!!
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
           
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + " "
                }
                if pm.subThoroughfare != nil {
                    addressString = addressString + pm.subThoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality!
                }
                callback(addressString)
            }
        })
    }
    
}
