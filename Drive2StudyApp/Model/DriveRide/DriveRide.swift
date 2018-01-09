//
//  DriveRide.swift
//  Drive2StudyApp
//
//  Created by IdoD on 05/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation

class DriveRide {
    var userName: String
    var fromWhere: String
    var type: String    // d for drive, r for ride
    var imageUrl:String?
    var lastUpdate:Date?
    
    
    init() {
        self.userName = ""
        self.fromWhere = ""
        self.type = ""
        self.imageUrl = ""
    }
    
    init(userName: String, fromWhere: String, type: String, imageUrl: String? = nil) {
        self.userName = userName
        self.fromWhere = fromWhere
        self.type = type
        self.imageUrl = imageUrl
    }
    
    // copy ctor
    init(dr: DriveRide) {
        self.userName = dr.userName
        self.fromWhere = dr.fromWhere
        self.type = dr.type
        self.imageUrl = dr.imageUrl
        self.lastUpdate = dr.lastUpdate
        
    }
    
    init(json:Dictionary<String,Any>){
        userName = json["userName"] as! String
        fromWhere = json["fromWhere"] as! String
        type = json["type"] as! String
        if let im = json["imageUrl"] as? String{
            imageUrl = im
        }
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["userName"] = userName
        json["fromWhere"] = fromWhere
        json["type"] = type
        if (imageUrl != nil){
            json["imageUrl"] = imageUrl!
        }
        json["lastUpdate"] = Date().toFirebase()
        return json
    }
    
    
}

