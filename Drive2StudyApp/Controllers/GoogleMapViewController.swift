//
//  GoogleMapViewController.swift
//  Drive2StudyApp
//
//  Created by idodror on 12.01.2018.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController, GMSMapViewDelegate {
    
    var driveList = [DriveRide]()
    var rideList = [DriveRide]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        ModelNotification.DriveList.observe { (list) in
            if list != nil {
                self.driveList = list!
                //create the marker and show in the map

            }
        }
        ModelNotification.RideList.observe { (list) in
            if list != nil {
                self.rideList = list!
                //create the marker and show in the map
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 32.090882, longitude: 34.774359, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.delegate = self

        // Creates markers for the map
        let myLatitude=32.090882
        let myLongtitude=34.774359
        let myMarker = GMSMarker()
        myMarker.position = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongtitude)
        myMarker.map = mapView
        
        let carLatitude=32.096642
        let carLongtitude=34.773158
        let carMarker = GMSMarker()
        carMarker.position = CLLocationCoordinate2D(latitude: carLatitude, longitude: carLongtitude)
        carMarker.icon = UIImage(named:"carMarker")
        carMarker.map = mapView
        
        let studentLatitude=32.075477
        let studentLongtitude=34.775730
        let studentMarker = GMSMarker()
        studentMarker.position = CLLocationCoordinate2D(latitude: studentLatitude, longitude: studentLongtitude)
        studentMarker.icon = UIImage(named:"studentMarker")
        studentMarker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
        return true
    }
    
}

