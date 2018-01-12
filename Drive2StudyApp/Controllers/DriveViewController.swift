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
        ModelNotification.DriveList.observe { (list) in
            if list != nil {
                self.driveList = list!
                self.tableView.reloadData()
            }
        }
        
        ModelNotification.ImgURL.observe { (url) in
            if url != nil && url != "" {
                Model.instance.getImage(urlStr: url! , callback: { (image) in
                    //TODO: parsing the url and get the userName
                    // update the image url per userName
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destViewController = segue.destination as! DriveRideSelectionViewController
        destViewController.type = "d"
        destViewController.selctedDriverRow = self.selctedRowCell
        
        
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
        self.selctedRowCell = tableView.cellForRow(at: indexPath) as! DriveRowCell

    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    
}
