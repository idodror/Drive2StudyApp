//
//  Model.swift
//  Drive2StudyApp
//
//  Created by IdoD on 31/12/2018.
//  Copyright © 2017 IdoD. All rights reserved.
//

import Foundation
import UIKit

class ModelNotificationBase<T>{
    var name:String?
    
    init(name:String){
        self.name = name
    }
    
    func observe(callback:@escaping (T?)->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(name!), object: nil, queue: nil) { (data) in
            if let data = data.userInfo?["data"] as? T {
                callback(data)
            }
        }
    }
    
    func post(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
}

class ModelNotification{
    static let StudentList = ModelNotificationBase<[Student]>(name: "StudentListNotification")
    static let Student = ModelNotificationBase<Student>(name: "StudentNotification")
    static let DriveList = ModelNotificationBase<[DriveRide]>(name: "DriveListNotification")
    static let RideList = ModelNotificationBase<[DriveRide]>(name: "RideListNotification")
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
}

class Model {
    static let instance = Model()
    static var studentCurrent = Student()
    
    lazy private var modelSql:ModelSql? = ModelSql()
    
    private init(){
    }
    
    func clear(){
        print("Model.clear")
        ModelFirebase.clearObservers()
    }
    
    func addStudent(st:Student){
        ModelFirebase.addStudent(st: st){(error) in
            //st.addStudentToLocalDb(database: self.modelSql?.database)
        }
        st.addStudentToLocalDb(database: self.modelSql?.database)
    }
    
    func addNewStudentToLocalDB(st:Student){
        st.addStudentToLocalDb(database: self.modelSql?.database)
    }
    
    func getStudentById(id:String, callback:@escaping (Student?)->Void){
        ModelFirebase.getStudentById(id: id) { (st) in
            if (st != nil) {
                callback(st!)
            } else {
                callback(nil)
            }
            
        }
    }
    
    func getAllStudents(callback:@escaping ([Student])->Void){
        print("Model.getAllStudents")
        
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Student.ST_TABLE)
        
        // get all updated records from firebase
        ModelFirebase.getAllStudents(lastUpdateDate, callback: { (students) in
            //update the local db
            print("got \(students.count) new records from FB")
            var lastUpdate:Date?
            for st in students{
                st.addStudentToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = st.lastUpdate
                }else{
                    if lastUpdate!.compare(st.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = st.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Student.ST_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Student.getAllStudentsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
    
    func getAllStudentsAndObserve(){
        print("Model.getAllStudentsAndObserve")
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Student.ST_TABLE)
        
        // get all updated records from firebase
        ModelFirebase.getAllStudentsAndObserve(lastUpdateDate, callback: { (students) in
            //update the local db
            print("got \(students.count) new records from FB")
            var lastUpdate:Date?
            for st in students{
                st.addStudentToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = st.lastUpdate
                }else{
                    if lastUpdate!.compare(st.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = st.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Student.ST_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Student.getAllStudentsFromLocalDb(database: self.modelSql?.database)
            print("\(totalList)")
            
            ModelNotification.StudentList.post(data: totalList)
        })
    }
    
    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        ModelFirebase.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
        }else{
            //2. get the image from Firebase
            ModelFirebase.getImageFromFirebase(url: urlStr, callback: { (image) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
            })
        }
    }
    
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    func addNewDriveRide(dr: DriveRide) {
        DriveRideModelFirebase.addNewDrive(dr: dr) { (error) in
            // 
        }
    }
}
