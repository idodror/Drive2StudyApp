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
    
    static func addNewDriveRide(dr: DriveRide) {
        DriveRideModelFirebase.addNewDriveRide(dr: dr) { (error) in
            //
        }
        //ModelNotification.DriveList.post(data: [dr])
     }
    
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

