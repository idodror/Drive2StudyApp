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
    static let ChatList = ModelNotificationBase<[ChatMessage]>(name: "ChatListNotification")
    static let ImgURL = ModelNotificationBase<String>(name: "ImageUrl")
    static let FullName = ModelNotificationBase<String>(name: "FullName")
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
}

class Model {
    static let instance = Model()
    static var studentCurrent = Student()
    
    lazy var modelSql:ModelSql? = ModelSql()

    
    private init(){
    }
    
    func clear(){
        print("Model.clear")
        ModelFirebase.clearObservers()
    }
    
    // calls the add new student function to the local DB and the firebase, post the imgUrl to the observer
    func addStudent(st:Student){
        ModelFirebase.addStudent(st: st){(error) in
            //st.addStudentToLocalDb(database: self.modelSql?.database)
        }
        st.addStudentToLocalDb(database: self.modelSql?.database)
        ModelNotification.ImgURL.post(data: st.imageUrl!)
    }
    
    // add new student to local DB
    func addNewStudentToLocalDB(st:Student){
        st.addStudentToLocalDb(database: self.modelSql?.database)
    }
    
    // gets an id of student and pull the data from firebase
    func getStudentById(id:String, callback:@escaping (Student?)->Void){
        let encodedID=id.replacingOccurrences(of: ".", with: ",")
        ModelFirebase.getStudentById(id: encodedID) { (st) in
            if (st != nil) {
                callback(st!)
            } else {
                callback(nil)
            }
            
        }
    }
    
    // saves the profile image to firebase (storage) and local DB
    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        ModelFirebase.saveProfileImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    // gets the image url and try to pull pull the image from firebase
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        if url != nil {
            let localImageName = url!.lastPathComponent
            if let image = self.getImageFromFile(name: localImageName){
                callback(image)
            } else {
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
    }
    
    // save image to local db
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    // returns the path of the images in the local DB
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // get the image from the local DB by name
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }    
}
