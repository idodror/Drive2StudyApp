//
//  Model.swift
//  TestFb
//
//  Created by Eliav Menachi on 14/12/2016.
//  Copyright © 2016 menachi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ModelFirebase {
    var ref: DatabaseReference!
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        ref?.child("iosxcxc test").setValue("this is sdsdffdsios test")
    }
    
}
