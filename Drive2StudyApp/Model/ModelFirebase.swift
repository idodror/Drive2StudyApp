
//
//  ModelFirebase.swift
//  Drive2StudyApp
//
//  Created by IdoD on 31/12/2018.
//  Copyright © 2017 IdoD. All rights reserved.
//
//

import Foundation
import Firebase
import FirebaseStorage


class ModelFirebase{
    
    static func addStudent(st:Student, completionBlock:@escaping (Error?)->Void){
        let ref = Database.database().reference().child("students").child(st.userName)
        ref.setValue(st.toFirebase())
        ref.setValue(st.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    static func getStudentById(id:String, callback:@escaping (Student?)->Void){
        
        let ref = Database.database().reference().child("students").child(id)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,Any>
            if (json != nil){
                let st = Student(json: json!)
                callback(st)
            } else { callback(nil) }
        })
    }
    
    static func getAllStudents(_ lastUpdateDate:Date? , callback:@escaping ([Student])->Void){
        print("FB: getAllStudents")
        let handler = {(snapshot:DataSnapshot) in
            var students = [Student]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let st = Student(json: json)
                        students.append(st)
                    }
                }
            }
            callback(students)
        }
        
        let ref = Database.database().reference().child("students")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
    static func getAllStudentsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Student])->Void){
        print("FB: getAllStudentsAndObserve")
        let handler = {(snapshot:DataSnapshot) in
            var students = [Student]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let st = Student(json: json)
                        students.append(st)
                    }
                }
            }
            callback(students)
        }
        
        let ref = Database.database().reference().child("students")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(DataEventType.value, with: handler)
        }else{
            ref.observe(DataEventType.value, with: handler)
        }
    }
    static func clearObservers(){
        let ref = Database.database().reference().child("students")
        ref.removeAllObservers()
    }
}
