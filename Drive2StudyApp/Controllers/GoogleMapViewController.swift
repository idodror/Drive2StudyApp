//
//  GoogleMapViewController.swift
//  Drive2StudyApp
//
//  Created by idodror on 12.01.2018.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class GoogleMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView = GMSMapView()
    var driveList = [DriveRide]()
    var rideList = [DriveRide]()
    var markersList = [GMSMarker]()
    var markerTappedDetails = String()
    
    //A string array to save all the names
    var nameArray = [String]()
    
    // for GPS location
    let locationManager = CLLocationManager()
    var camera = GMSCameraPosition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        _ = ModelNotification.DriveList.observe { (list) in
            if list != nil {
                self.driveList = list!
                self.markersList.removeAll()
                self.mapView.clear()
                self.addAllMarkersToMap()
            }
        }
        _ = ModelNotification.RideList.observe { (list) in
            if list != nil {
                self.rideList = list!
                self.markersList.removeAll()
                self.mapView.clear()
                self.addAllMarkersToMap()
            }
        }
    }
    
    // listen to the changes in the core location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationAndMarkersOnMap()
        self.locationManager.stopUpdatingLocation()
    }
    
    // set the camera to the map by the current location and add all the other markers to the map (gets the data from drivelist and ridelist)
    func showCurrentLocationAndMarkersOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 13)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.setAllGesturesEnabled(true)
        
        mapView.clear()
        // adds the current location marker (red pin)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current Location"
        marker.title = "My Location"
        marker.map = mapView
        view = mapView
        mapView.delegate = self
        addAllMarkersToMap()
    }

    func addAllMarkersToMap() {
        for dr in self.driveList {
            self.addMarkerToMap(dr: dr)
        }
        for dr in self.rideList {
            self.addMarkerToMap(dr: dr)
        }
    }
    
    // Uses Alamofire pod to send http get request to googleapis to get lat/lng from address
    // callback Double array (first val is lat, second val is lng)
    func getLatLangFromAddress(address: String, callback:@escaping ([Double])->Void) {
        let postParameters:[String: Any] = [ "address": address]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        var cor = [Double]()
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value
            {
                let resultParams = JSON(receivedResults)
                if resultParams["status"] == "OK" {
                    cor.append(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue)
                    cor.append(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue)
                    callback(cor)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // gets DriverRide object (with address) and gets the cooridinates of this address and put the marker on the map
    // marker icon depends on the type value of the object (r for ride, d for drive)
    func addMarkerToMap(dr: DriveRide) {
        
        getLatLangFromAddress(address: dr.fromWhere) { (corArray) in
            self.markersList.append(GMSMarker())
            self.markersList[self.markersList.count - 1].position = CLLocationCoordinate2D(latitude: corArray[0], longitude: corArray[1])
            var markerIcon: String
            if dr.type == "d" {
                markerIcon = "carMarker"
                self.markersList[self.markersList.count - 1].title = "d" + dr.userName
            } else {
                markerIcon = "studentMarker"
                self.markersList[self.markersList.count - 1].title = "r" + dr.userName
            }
            self.markersList[self.markersList.count - 1].icon = UIImage(named: markerIcon)

            self.markersList[self.markersList.count - 1].map = self.mapView

        }
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 32.090882, longitude: 34.774359, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.delegate = self
    }
    
    // check which maker tapped by the user and opens the relevant popup to ride/drive with him
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
        if marker.title! != "My Location" {
            markerTappedDetails = marker.title!
            print("\(String(markerTappedDetails.dropFirst()))")
            print("\(markerTappedDetails[markerTappedDetails.startIndex])")
            performSegue(withIdentifier: "driveRideSelectionOnMap", sender: self)
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driveRideSelectionOnMap" {
            let destViewController = segue.destination as! DriveRideSelectionViewController
            let firstChar = markerTappedDetails[markerTappedDetails.startIndex]
            destViewController.username = String(markerTappedDetails.dropFirst())
            destViewController.type = String(firstChar)
            destViewController.fromMap = 1
        }
    }
}

