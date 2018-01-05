//
//  Student+sql.swift
//  Drive2StudyApp
//
//  Created by IdoD on 31/12/2018.
//  Copyright © 2017 IdoD. All rights reserved.
//

import Foundation


extension Student {
    static let ST_TABLE = "STUDENTS"
    static let ST_USERNAME = "USERNAME"
    static let ST_FNAME = "FNAME"
    static let ST_LNAME = "LNAME"
    static let ST_PHONE = "PHONE"
    static let ST_STUDY = "STUDY"
    static let ST_PASSWORD = "PASSWORD"
    static let ST_LAST_UPDATE = "ST_LAST_UPDATE"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + ST_TABLE + " ( "
            + ST_USERNAME + " TEXT PRIMARY KEY, "
            + ST_FNAME + " TEXT, "
            + ST_LNAME + " TEXT, "
            + ST_PHONE + " TEXT, "
            + ST_STUDY + " TEXT, "
            + ST_PASSWORD + " TEXT, "
            + ST_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addStudentToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Student.ST_TABLE
            + "("
            + Student.ST_USERNAME + ","
            + Student.ST_FNAME + ","
            + Student.ST_LNAME + ","
            + Student.ST_PHONE + ","
            + Student.ST_STUDY + ","
            + Student.ST_PASSWORD + ","
            + Student.ST_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let userName = self.userName.cString(using: .utf8)
            let fName = self.fName.cString(using: .utf8)
            /*var imageUrl = "".cString(using: .utf8)
             if self.imageUrl != nil {
             imageUrl = self.imageUrl!.cString(using: .utf8)
             }*/
            let lName = self.lName.cString(using: .utf8)
            let phoneNumber = self.phoneNumber.cString(using: .utf8)
            let study = self.study.cString(using: .utf8)
            let password = self.password.cString(using: .utf8)
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, fName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, lName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, phoneNumber,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, study,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, password,-1,nil);
            
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 7, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllStudentsFromLocalDb(database:OpaquePointer?)->[Student]{
        var students = [Student]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from STUDENTS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                //need to change the sqlite3_column_text
                let userName =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let fName =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let lName =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let phoneNumber =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let study =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let password = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                
                //var imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,6))
                //print("read from filter st: \(stId) \(name) \(imageUrl)")
                /*if (imageUrl != nil && imageUrl == ""){
                    imageUrl = nil
                }*/
                let student = Student(userName: userName!, fName: fName!, lName: lName!, phoneNumber: phoneNumber!, study: study!, password: password!)
                student.lastUpdate = Date.fromFirebase(update)
                students.append(student)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return students
    }
    
}
