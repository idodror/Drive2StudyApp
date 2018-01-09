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

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModelNotification.DriveList.observe { (list) in
            if list != nil {
                self.driveList = list!
                self.tableView.reloadData()
            }
        }
        DriveRideModel.getAllDriveRideAndObserve(driveOrRideTable: "d")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*        if (segue.identifier == "showDetails"){
         let studentViewController:StudentDetailsViewController = segue.destination as! StudentDetailsViewController
         let content = data[selctedRow!];
         studentViewController.studentNameText = content
         }*/
        let destViewController = segue.destination as! ChooseLocationViewController
        destViewController.type = "d"
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
        
        cell.userNameLabel.text = content.userName
        cell.fromWhereLabel.text = content.fromWhere
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        //performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    
}
