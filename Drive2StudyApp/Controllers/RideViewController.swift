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

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DriveRideModel.getAllDriveRideAndObserve(driveOrRideTable: "r")
        ModelNotification.RideList.observe { (list) in
            if list != nil {
                self.rideList = list!
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*        if (segue.identifier == "showDetails"){
         let studentViewController:StudentDetailsViewController = segue.destination as! StudentDetailsViewController
         let content = data[selctedRow!];
         studentViewController.studentNameText = content
         }*/
        let destViewController = segue.destination as! ChooseLocationViewController
        destViewController.type = "r"
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
        
        cell.userNameLabel.text = content.userName
        cell.fromWhereLabel.text = content.fromWhere
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        //performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
    }
    
}
