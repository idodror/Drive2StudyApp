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

class GoogleMapViewController: UIViewController, GMSMapViewDelegate {
    
    var mapView = GMSMapView()
    var driveList = [DriveRide]()
    var rideList = [DriveRide]()
    var markersList = [GMSMarker]()
    var markerTappedDetails = String()
    
    //A string array to save all the names
    var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        ModelNotification.DriveList.observe { (list) in
            if list != nil {
                self.driveList = list!
                self.markersList.removeAll()
                self.mapView.clear()
                self.addAllMarkersToMap()
            }
        }
        ModelNotification.RideList.observe { (list) in
            if list != nil {
                self.rideList = list!
                self.markersList.removeAll()
                self.mapView.clear()
                self.addAllMarkersToMap()
            }
        }
    }

    func addAllMarkersToMap() {
        for dr in self.driveList {
            self.addMarkerToMap(dr: dr)
        }
        for dr in self.rideList {
            self.addMarkerToMap(dr: dr)
        }
    }
    
    func getLatLangFromAddress(address: String, callback:@escaping ([Double])->Void) {
        let postParameters:[String: Any] = [ "address": address]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        var cor = [Double]()
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value
            {
                let resultParams = JSON(receivedResults)
                //print(resultParams["status"]) // OK, ERROR
                //print(resultParams) // RESULT JSON
                if resultParams["status"] == "OK" {
                    cor.append(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue)
                    cor.append(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue)
                    callback(cor)
                    //print("\(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue), ") // approximately latitude
                    //print("\(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue)\n") // approximately longitude
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        mapView.clear()
        addAllMarkersToMap()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
        markerTappedDetails = marker.title!
        print("\(String(markerTappedDetails.dropFirst()))")
        print("\(markerTappedDetails[markerTappedDetails.startIndex])")
        performSegue(withIdentifier: "driveRideSelectionOnMap", sender: self)
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

