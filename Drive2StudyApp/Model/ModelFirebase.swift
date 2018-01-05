
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
    
    /*lazy var storageRef = FIRStorage.storage().reference(forURL:
     "gs://drive2studyapp.appspot.com")*/
    //i cahnged the saveImageToFirebase method to static, so i insert the storageRef in static method
    
    static func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://drive2studyapp.appspot.com/")
        
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    static func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
}
