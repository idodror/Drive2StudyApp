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
    
    init(userName: String, fName: String, lName: String, phoneNumber: String, study: String) {
        self.userName = userName
        self.fName = fName
        self.lName = lName
        self.phoneNumber = phoneNumber
        self.study = study
    }
    
    init(fromJson:[String:Any]){
        userName = fromJson["userName"] as! String
        fName = fromJson["fName"] as! String
        lName = fromJson["lName"] as! String
        phoneNumber = fromJson["phoneNumber"] as! String
        study = fromJson["study"] as! String
        daysInCollege = fromJson["daysInCollege"] as! [Int]
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["userName"] = userName
        json["fName"] = fName
        json["lName"] = lName
        json["phoneNumber"] = phoneNumber
        json["study"] = study
        json["daysInCollege"] = daysInCollege
        return json
    }
    
    
}
