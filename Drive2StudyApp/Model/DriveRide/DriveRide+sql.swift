//
//  DriveRide+sql.swift
//  Drive2StudyApp
//
//  Created by IdoD on 06/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation

extension DriveRide {
    static var DR_TABLE = ""
    static let DR_USERNAME = "USERNAME"
    static let DR_FROM = "FROMWHERE"
    static let DR_TYPE = "TYPE"
    static let DR_LAST_UPDATE = "DR_LAST_UPDATE"
    
    public static func changeTableName(name: String) {
        if name == "d" {
            DR_TABLE = "DRIVE"
        } else {
            DR_TABLE = "RIDE"
        }
    }
    
    static func createTable(database:OpaquePointer?, driveOrRideTable: String)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        DriveRide.changeTableName(name: driveOrRideTable)
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + DR_TABLE + " ( "
            + DR_USERNAME + " TEXT PRIMARY KEY, "
            + DR_FROM + " TEXT, "
            + DR_TYPE + " TEXT, "
            + DR_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addDriveRideToLocalDb(database:OpaquePointer?, driveOrRideTable: String){
        var sqlite3_stmt: OpaquePointer? = nil
        
        DriveRide.changeTableName(name: driveOrRideTable)
        
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + DriveRide.DR_TABLE
            + "("
            + DriveRide.DR_USERNAME + ","
            + DriveRide.DR_FROM + ","
            + DriveRide.DR_TYPE + ","
            + DriveRide.DR_LAST_UPDATE + ") VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let userName = self.userName.cString(using: .utf8)
            let fromWhere = self.fromWhere.cString(using: .utf8)
            let type = self.type.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, fromWhere,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, type,-1,nil);
            
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 4, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully to driveride table")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllDriveRideFromLocalDb(database:OpaquePointer?, driveOrRideTable: String)->[DriveRide]{
        DriveRide.changeTableName(name: driveOrRideTable)
        var driverides = [DriveRide]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " + DR_TABLE + ";",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                //need to change the sqlite3_column_text
                let userName =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let fromWhere =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let type =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,3))
                
                let driveRide = DriveRide(userName: userName!, fromWhere: fromWhere!, type: type!)
                driveRide.lastUpdate = Date.fromFirebase(update)
                driverides.append(driveRide)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return driverides
    }
    
}
