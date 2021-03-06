//
//  DriveRideSelectionViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 12/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import UIKit
import JSQMessagesViewController

// Popup style for show the selected row in the drive/ride tables and show option fro send automatically messages
class DriveRideSelectionViewController: UIViewController {

    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var learningLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var driverideButton: UIButton!
    
    var type: String?
    var username: String?
    var selctedDriverRow:DriveRowCell?
    var selctedRiderRow:RideRowCell?
    var fromMap: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilPicture.frame = CGRect(x: 127, y: 8, width: 80, height: 80)
        profilPicture.layer.cornerRadius = 0.5 * profilPicture.bounds.size.width
        profilPicture.clipsToBounds = true
        
        loadData()
    }
    
    func loadData() {
        if(self.type == "d"){
            
            if(self.selctedDriverRow?.userNameLabel.text! == Model.studentCurrent.userName.replacingOccurrences(of: ",", with: ".")){
                self.driverideButton.isEnabled = false
            }
            self.driverideButton.setTitle("Drive Me!", for: .normal)
            profilPicture.image = selctedDriverRow?.profilePicture.image
            userNameLabel.text = selctedDriverRow?.userNameLabel.text
        }
        else{
            
            if(self.selctedRiderRow?.userNameLabel.text! == Model.studentCurrent.userName.replacingOccurrences(of: ",", with: ".")){
                self.driverideButton.isEnabled = false
            }
            self.driverideButton.setTitle("Ride You!", for: .normal)
            profilPicture.image = selctedRiderRow?.profilePicture.image
            userNameLabel.text = selctedRiderRow?.userNameLabel.text

        }
        
        if username == Model.studentCurrent.userName {
            self.driverideButton.isEnabled = false
        }
        
        if (username != nil) {
            userNameLabel.text = username
        }

        if(userNameLabel.text != nil){

            userNameLabel.text! = userNameLabel.text!.replacingOccurrences(of: ",", with: ".")
            Model.instance.getStudentById(id: userNameLabel.text!) { (student) in
                if (student != nil) {
                    self.learningLabel.text = student?.study
                    var list = student?.daysInCollege
                    if(list != nil){
                    self.daysLabel.text = ""
                    for i in 0..<list!.count{
                        if list![i]==1{
                            self.daysLabel.text?+=self.getDay(i) + "\n"
                            }
                        }
                    }
                    if self.fromMap == 1{
                        if(student?.imageUrl != nil && student?.imageUrl != ""){
                            Model.instance.getImage(urlStr: (student?.imageUrl)! , callback: { (image) in
                                
                                self.profilPicture.image = image
                                
                            })
                        }
                        self.fromMap = 0
                    }
                }
            }
        }
    }
    
    func getDay(_ day: Int) -> String{
        switch day {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return "NA"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissPopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func driveRideButtonPressed(_ sender: UIButton) {
        if self.type == "d"{
            self.sendAutoMessage(text: "Hi! Can I have a ride to College?")
        }
        else{
             self.sendAutoMessage(text: "Hi! Would you like a ride to College?")
        }
    }
    
    func sendAutoMessage(text: String){
        let user = userNameLabel.text
        let receiver = user?.replacingOccurrences(of: ".", with: ",")
        let tempsender = Model.studentCurrent.userName
        let sender = tempsender.replacingOccurrences(of: ",", with: ".")
        let ref = ChatModelFirebase.refs.databaseChats.childByAutoId()
        let message = ["sender_id": Model.studentCurrent.userName+"$"+receiver!,"receiver_id": receiver, "name": sender, "text": text]
        ref.setValue(message)
        
        self.dismiss(animated: true, completion: nil)
    }

    
}
