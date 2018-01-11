//
//  DriveRideHandler.swift
//  Drive2StudyApp
//
//  Created by admin on 11/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import Firebase

class DriveHandler{
    
    let database = Database.database().reference()

    init(){
        
        let postRef = self.database.child("drive")

        postRef.observe(.childAdded) { (snapshot) -> Void in
            print("drive child is added!")
            
            
        }
        
        postRef.observe(.childChanged) { (snapshot) -> Void in
            print("drive child is changed!")
        }
        
        postRef.observe(.childRemoved) { (snapshot) -> Void in
            print("drive child is removed!")
        }
    }
    
}
