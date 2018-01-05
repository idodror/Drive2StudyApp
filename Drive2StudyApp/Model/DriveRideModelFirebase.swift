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
    
    static func addNewDrive(dr:DriveRide, completionBlock:@escaping (Error?)->Void){
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
    
}
