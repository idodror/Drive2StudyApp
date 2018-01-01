//
//  Model.swift
//  SqliteDemo_6_12
//
//  Created by Eliav Menachi on 06/12/2017.
//  Copyright © 2017 menachi. All rights reserved.
//

import Foundation

class Model{
    static let instance = Model()
    
    let modelSql = ModelSql()
    
    func addNewStudent(student:Student){
        Student.addNewStudent(toDB:modelSql.database, student: student)
    }
    
    func getAllStudents()->[Student]{
        return Student.getAllStudents(fromDB:modelSql.database)
    }
    
    func getStudent(withId stId:String)->Student?{
        return Student.getStudent(fromDB: modelSql.database, withId: stId)
    }
    
    func deleteStudent(withId stId:String){
        return Student.deleteStudent(fromDB: modelSql.database, withId: stId)
    }
    
}
