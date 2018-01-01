//
//  Student.swift
//  Drive2StudyApp
//
//  Created by IdoD on 27/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import Foundation

class Student {
    var userName: String
    var fName: String
    var lName: String
    var phoneNumber: String
    var study: String
    var daysInCollege = Array(repeating: 0, count: 7)
    var lastUpdate:Date?

    init(userName: String, fName: String, lName: String, phoneNumber: String, study: String) {
        self.userName = userName
        self.fName = fName
        self.lName = lName
        self.phoneNumber = phoneNumber
        self.study = study
        
    }
    
    init(json:Dictionary<String,Any>){
        userName = json["userName"] as! String
        fName = json["fName"] as! String
        lName = json["lName"] as! String
        phoneNumber = json["phoneNumber"] as! String
        study = json["study"] as! String
        daysInCollege = json["daysInCollege"] as! [Int]
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["userName"] = userName
        json["fName"] = fName
        json["lName"] = lName
        json["phoneNumber"] = phoneNumber
        json["study"] = study
        json["daysInCollege"] = daysInCollege
        json["lastUpdate"] = " " //TBD!!!!!!!! timestamp from DB
        return json
    }
    
    
}
