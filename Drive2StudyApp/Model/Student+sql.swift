//
//  Student+sql.swift
//  SqliteDemo_6_12
//
//  Created by Eliav Menachi on 06/12/2017.
//  Copyright © 2017 menachi. All rights reserved.
//

import Foundation


extension Student{
    static let STUDENT_TABLE = "STUDENTS"
    static let STID = "STID"
    static let NAME = "NAME"
    static let PHONE = "PHONE"
    
    static func createTable(toDB database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + STUDENT_TABLE + " (" +
            STID + " TEXT PRIMARY KEY, " +
            NAME + " TEXT, " +
            PHONE + " TEXT)", nil, nil, &errormsg)
        if(res != 0){
            print("error creating table");
            return false
        }
        return true
    }
    
    static func addNewStudent(toDB database:OpaquePointer?, student:Student){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " +
            STUDENT_TABLE + " ( " +
            STID + ", " +
            NAME + ", " +
            PHONE + " ) VALUES (?,?,?);",-1,
            &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = student.userName.cString(using: .utf8)
            let name = student.fName.cString(using: .utf8)
            let phone = student.lName.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, phone,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }

    static func getAllStudents(fromDB database:OpaquePointer?)->[Student]{
        var students = [Student]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " +
            STUDENT_TABLE + ";",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let userName  = String(cString:sqlite3_column_text(sqlite3_stmt,0))
                let fName  = String(cString:sqlite3_column_text(sqlite3_stmt,1))
                let lName  = String(cString:sqlite3_column_text(sqlite3_stmt,2))
                
                students.append(Student(userName: userName, fName: fName, lName: lName, phoneNumber: "b", study: "b"))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return students
    }
    
    static func getStudent(fromDB database:OpaquePointer?, withId stId:String)->Student?{
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " +
            STUDENT_TABLE + " where " +
            STID + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, stId.cString(using: .utf8),-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let userName  = String(cString:sqlite3_column_text(sqlite3_stmt,0))
                let fName  = String(cString:sqlite3_column_text(sqlite3_stmt,1))
                let lName  = String(cString:sqlite3_column_text(sqlite3_stmt,2))
                
                return Student(userName: userName, fName: fName, lName: lName, phoneNumber: "b", study: "b")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return nil
    }
    
    static func deleteStudent(fromDB database:OpaquePointer?, withId stId:String){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"delete from " +
            STUDENT_TABLE + " where " +
            STID + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, stId.cString(using: .utf8),-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) != SQLITE_DONE){
                print ("failes executing deleteStudent")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }

}
