//
//  ChatTableViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 28/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController{

    
    var selctedRow:Int?
    var studentList = [Student]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.instance.getAllStudentsAndObserve()
        ModelNotification.StudentList.observe { (list) in
            if list != nil {
                self.studentList = list!
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       /* let destViewController = segue.destination as! ChooseLocationViewController
        destViewController.type = "d"*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatRowCell = tableView.dequeueReusableCell(withIdentifier: "ChatRowCell", for: indexPath) as! ChatRowCell
        
        let content = studentList[indexPath.row]
        
        cell.userNameLabel.text = content.userName
        if(content.imageUrl != nil){
            Model.instance.getImage(urlStr: content.imageUrl! , callback: { (image) in
                cell.profilePicture.image = image
                
            })}
        
        return cell
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        //performSegue(withIdentifier: "showDetails", sender: self)
    }

    @IBAction func OpenChatPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "OpenChat", sender: (Any).self)
    }
}
