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
    
    static func getAllDriveRideAndObserve(_ lastUpdateDate:Date?, driveOrRide: String, callback:@escaping ([DriveRide])->Void){
        print("FB: getAllDriveRides")
        let handler = {(snapshot:DataSnapshot) in
            var driverides = [DriveRide]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let dr = DriveRide(json: json)
                        driverides.append(dr)
                    }
                }
            }
            callback(driverides)
        }
        
        var ref = Database.database().reference()
        if driveOrRide == "d" {
            ref = ref.child("drive")
        } else {
            ref = ref.child("ride")
        }
        
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
}
