//
//  DriveRideModelFirebase.swift
//  Drive2StudyApp
//
//  Created by IdoD on 05/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class DriveRideModelFirebase {
    
    static func addNewDriveRide(dr:DriveRide, completionBlock:@escaping (Error?)->Void){
        var table = "";
        if dr.type == "r" {
            table = "ride"
        } else { table = "drive" }
        let ref = Database.database().reference().child(table).child(dr.userName)
        ref.setValue(dr.toFirebase())
        ref.setValue(dr.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    static func getAllDriveRideAndObserve(driveOrRide: String, callback:@escaping ([DriveRide]?)->Void){
        var myRef = Database.database().reference().child("drive")
        if driveOrRide == "r" {
            myRef = Database.database().reference().child("ride")
        }
        
        myRef.observe(.value, with: { (snapshot) in
            if let values = snapshot.value as? [String:[String:Any]]{
                var driveRideArray = [DriveRide]()
                for drJson in values{
                    let dr = DriveRide(json: drJson.value)
                    driveRideArray.append(dr)
                }
                callback(driveRideArray)
            }else{
                callback(nil)
            }
        })
    }
    
    
    
}

