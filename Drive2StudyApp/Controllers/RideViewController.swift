//
//  RideViewController.swift
//  Drive2StudyApp
//
//  Created by delver on 26.12.2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class RideViewController: UITableViewController {
    
    var selctedRow:Int?
    var rideList = [DriveRide]()
    var selctedRowCell:RideRowCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DriveRideModel.getAllDriveRideAndObserve(driveOrRideTable: "r")
        _ = ModelNotification.RideList.observe { (list) in
            if list != nil {
                self.rideList = list!
                self.tableView.reloadData()
            }
        }
        
        _ = ModelNotification.ImgURL.observe { (url) in
            if url != nil && url != "" {
                Model.instance.getImage(urlStr: url! , callback: { (image) in
                    //TODO: parsing the url and get the userName
                    // update the image url per userName
                    print("Url: \(url!)")
                    var urltemp = url!
                    urltemp.removeSubrange(urltemp.startIndex..<urltemp.index(urltemp.startIndex, offsetBy: 84))
                    var str = urltemp.split(separator: "?")
                    let userName = str[0]
                    let finalUserName = userName.replacingOccurrences(of: ",", with: ".")
                    print("New Url: \(finalUserName)")
                    
                    for drive in self.rideList{
                        if drive.userName == userName{
                            drive.imageUrl = url!
                            self.tableView.reloadData()
                            break
                        }
                    }
                })
            }
        }
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.records.removeAll()
        self.UpdateCurrentVisibleCell()
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewRideSegue" {
            let destViewController = segue.destination as! ChooseLocationViewController
            destViewController.type = "r"
        }
        if segue.identifier == "rideDetailsSegue" {
            let destViewController = segue.destination as! DriveRideSelectionViewController
            destViewController.type = "r"
            destViewController.selctedRiderRow = self.selctedRowCell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RideRowCell = tableView.dequeueReusableCell(withIdentifier: "rideRowCell", for: indexPath) as! RideRowCell
        
        let content = rideList[indexPath.row]
        
        let decodedID=content.userName.replacingOccurrences(of: ",", with: ".")
        cell.userNameLabel.text = decodedID
        cell.fromWhereLabel.text = content.fromWhere
        if(content.imageUrl != nil && content.imageUrl != ""){
            Model.instance.getImage(urlStr: content.imageUrl! , callback: { (image) in
                cell.profilePicture.image = image
                print("************************Image for user name (Event): \(cell.userNameLabel.text!)")
            })
        }
        
        else{
            cell.profilePicture.image = UIImage(named: "AvatarBigPicture")
        }
        
        return cell
    }
    
    // listens to selecet row click
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let rideItem = rideList[indexPath.row]
            if(rideItem.userName == Model.studentCurrent.userName){ //delete option possible only on current item
                DriveRideModel.RemoveDriveRide(driver: rideItem)
            }
            
        }
    }
    
    // listens to select row click
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        self.selctedRowCell = (tableView.cellForRow(at: indexPath) as! RideRowCell)
        performSegue(withIdentifier: "rideDetailsSegue", sender: nil)

    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
    }
    
}
