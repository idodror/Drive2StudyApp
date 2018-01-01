//
//  ModelSql.swift
//  SqliteDemo_6_12
//
//  Created by Eliav Menachi on 06/12/2017.
//  Copyright © 2017 menachi. All rights reserved.
//

import Foundation

class ModelSql {
    var database: OpaquePointer? = nil

    init() {
        //opem the DB file
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
        
        //create the tables if not existed
        Student.createTable(toDB: database)
    }
}
