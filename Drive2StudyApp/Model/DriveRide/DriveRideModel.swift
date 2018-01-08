//
//  DriveRideModel.swift
//  Drive2StudyApp
//
//  Created by IdoD on 05/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import UIKit

extension Model {
    
    func addNewDriveRide(dr: DriveRide) {
        DriveRideModelFirebase.addNewDriveRide(dr: dr) { (error) in
            //
        }
        dr.addDriveRideToLocalDb(database: self.modelSql?.database, driveOrRideTable: dr.type)
        //ModelNotification.DriveList.post(data: [dr])
        
     }
     
     func getAllDriveRideAndObserve(driveOrRideTable: String) {
         print("Model.getAllDriveRideAndObserve")
         // get last update date from SQL
         let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: DriveRide.DR_TABLE)
        
         // get all updated records from firebase
         DriveRideModelFirebase.getAllDriveRideAndObserve(lastUpdateDate, driveOrRide: driveOrRideTable, callback: { (driverides) in
         //update the local db
         print("got \(driverides.count) new records from FB")
         var lastUpdate:Date?
         for dr in driverides {
         dr.addDriveRideToLocalDb(database: self.modelSql?.database, driveOrRideTable: driveOrRideTable)
         if lastUpdate == nil{
            lastUpdate = dr.lastUpdate
         } else {
                 if lastUpdate!.compare(dr.lastUpdate!) == ComparisonResult.orderedAscending{
                    lastUpdate = dr.lastUpdate
                }
             }
         }
         
         DriveRide.changeTableName(name: driveOrRideTable)
         
         //upadte the last update table
         if (lastUpdate != nil){
         LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: DriveRide.DR_TABLE, lastUpdate: lastUpdate!)
         }
         
         //get the complete list from local DB
         let totalList = DriveRide.getAllDriveRideFromLocalDb(database: self.modelSql?.database, driveOrRideTable: driveOrRideTable)
         print("\(totalList)")
         
         if driveOrRideTable == "d" {
         ModelNotification.DriveList.post(data: totalList)
         } else {
                ModelNotification.RideList.post(data: totalList)
            }
         
         })
     }
}

