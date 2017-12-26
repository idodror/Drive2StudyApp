//
//  MapViewController.swift
//  Drive2StudyApp
//
//  Created by delver on 25.12.2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 32.090882, longitude: 34.774359, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
