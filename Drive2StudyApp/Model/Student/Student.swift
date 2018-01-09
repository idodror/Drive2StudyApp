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
    var study: String
    var daysInCollege = Array(repeating: 0, count: 7)
    var imageUrl:String?
    var LoginType: String
    var lastUpdate:Date?
    
    
    init() {
        self.userName = ""
        self.fName = ""
        self.lName = ""
        self.study = ""
        self.imageUrl = ""
        self.LoginType = ""
    }

    init(userName: String, fName: String, lName: String, study: String, imageUrl:String? = nil, LoginType: String) {
        self.userName = userName
        self.fName = fName
        self.lName = lName
        self.study = study
        self.imageUrl = imageUrl
        self.LoginType = LoginType
    }
    
    // copy ctor
    init(st: Student) {
        self.userName = st.userName
        self.fName = st.fName
        self.lName = st.lName
        self.study = st.study
        self.daysInCollege = st.daysInCollege
        self.imageUrl = st.imageUrl
        self.LoginType = st.LoginType
        self.lastUpdate = st.lastUpdate
        
    }
    
    init(json:Dictionary<String,Any>){
        userName = json["userName"] as! String
        fName = json["fName"] as! String
        lName = json["lName"] as! String
        study = json["study"] as! String
        daysInCollege = json["daysInCollege"] as! [Int]
        if let im = json["imageUrl"] as? String{
            imageUrl = im
        }
        LoginType = json["LoginType"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["userName"] = userName
        json["fName"] = fName
        json["lName"] = lName
        json["study"] = study
        json["daysInCollege"] = daysInCollege
        if (imageUrl != nil){
            json["imageUrl"] = imageUrl!
        }
        json["LoginType"] = LoginType
        json["lastUpdate"] = Date().toFirebase()
        return json
    }
    
    
}
