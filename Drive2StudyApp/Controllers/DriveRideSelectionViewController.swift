//
//  DriveRideSelectionViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 12/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import UIKit

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
            self.driverideButton.setTitle("Drive Me!", for: .normal)
            profilPicture.image = selctedDriverRow?.profilePicture.image
            userNameLabel.text = selctedDriverRow?.userNameLabel.text
        }
        else{
            self.driverideButton.setTitle("Ride You!", for: .normal)
            profilPicture.image = selctedRiderRow?.profilePicture.image
            userNameLabel.text = selctedRiderRow?.userNameLabel.text

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func driveRideButtonPressed(_ sender: UIButton) {
        if self.type == "d"{
            /*var newRide = DriveRide(userName: Model.studentCurrent.userName, fromWhere: "GPS", type: "r", imageUrl: Model.studentCurrent.imageUrl)
            DriveRideModel.addNewDriveRide(dr: newRide)*/
            
            //TODO: send default chat from current to selected row user "Drive me please"
            self.dismiss(animated: true, completion: nil)

        }
        else{
            /*var newRide = DriveRide(userName: Model.studentCurrent.userName, fromWhere: "GPS", type: "d", imageUrl: Model.studentCurrent.imageUrl)
            DriveRideModel.addNewDriveRide(dr: newRide)*/
            
            //TODO: send default chat from current to selected row user "i will pick you"
            self.dismiss(animated: true, completion: nil)

        }
    }
    @IBAction func sendMessagebuttonPressed(_ sender: UIButton) {
        
    }
    
}
