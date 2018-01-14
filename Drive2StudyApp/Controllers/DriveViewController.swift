//
//  DriveViewController.swift
//  Drive2StudyApp
//
//  Created by delver on 26.12.2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class DriveViewController: UITableViewController {
    
    var selctedRow:Int?
    var driveList = [DriveRide]()
    var selctedRowCell:DriveRowCell?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DriveRideModel.getAllDriveRideAndObserve(driveOrRideTable: "d")
        _ = ModelNotification.DriveList.observe { (list) in
            if list != nil {
                self.driveList = list!
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
                    
                    for drive in self.driveList{
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewDriveSegue" {
            let destViewController = segue.destination as! ChooseLocationViewController
            destViewController.type = "d"
        }
        if segue.identifier == "driverDetailsSegue" {
            let destViewController = segue.destination as! DriveRideSelectionViewController
            destViewController.type = "d"
            destViewController.selctedDriverRow = self.selctedRowCell
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
        return driveList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DriveRowCell = tableView.dequeueReusableCell(withIdentifier: "driveRowCell", for: indexPath) as! DriveRowCell
        
        let content = driveList[indexPath.row]
        
        let decodedID=content.userName.replacingOccurrences(of: ",", with: ".")
        cell.userNameLabel.text = decodedID
        cell.fromWhereLabel.text = content.fromWhere
        if(content.imageUrl != nil){
        Model.instance.getImage(urlStr: content.imageUrl! , callback: { (image) in
            cell.profilePicture.image = image
            
        })}
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let driverItem = driveList[indexPath.row]
            DriveRideModel.RemoveDriveRide(driver: driverItem)
            
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        self.selctedRowCell = (tableView.cellForRow(at: indexPath) as! DriveRowCell)
        performSegue(withIdentifier: "driverDetailsSegue", sender: nil)

    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    
}
