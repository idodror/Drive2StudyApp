//
//  DriveRideModel.swift
//  Drive2StudyApp
//
//  Created by IdoD on 05/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import UIKit

class DriveRideModel {
    
    // calls the add new drive/ride object to the firebase
    static func addNewDriveRide(dr: DriveRide) {
        DriveRideModelFirebase.addNewDriveRide(dr: dr) { (error) in
            //
        }
        //ModelNotification.DriveList.post(data: [dr])
     }
    
    // call to get all te drive/rides (depend of the type) from the firebase and post notificaion to the relevant list
    static func getAllDriveRideAndObserve(driveOrRideTable: String) {
        
        print("Model.getAllDriveRideAndObserve")
        
        DriveRideModelFirebase.getAllDriveRideAndObserve(driveOrRide: driveOrRideTable, callback: { (list) in
            //print("number of objects: \(list!.count)")
            if list != nil {
                if driveOrRideTable == "d" {
                    ModelNotification.DriveList.post(data: list!)
                } else {
                    ModelNotification.RideList.post(data: list!)
                }
            }
        })
        
    }
    
    static func RemoveDriveRide(driver: DriveRide){
        DriveRideModelFirebase.RemoveDriveRide(driver: driver)
    }
}

