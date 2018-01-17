//
//  ChatTableViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 28/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController, NewMessageChatSectionViewControllerDelegate{

    
    var selectedRow:Int?
    var chatList = [ChatMessage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all relevant chat for current user
        ChatModel.getAllChatByReceiveIdObserve(receiveName: Model.studentCurrent.userName)
        
        // set a listener for changes in the chat list from firebase
        _ = ModelNotification.ChatList.observe { (list) in
            if list != nil {
                self.chatList = list!
                self.tableView.reloadData()
            }
        }
        
        // set a listener for notification about image chnages
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
                    let cells = self.tableView.visibleCells as! Array<ChatRowCell>
                    
                    for cell in cells {
                        if cell.userNameLabel.text! == userName{
                                Model.instance.getImage(urlStr: url! , callback: { (image) in
                                        cell.profilePicture.image = image
                                })
                            
                            self.tableView.reloadData()
                            break
                        }
                    }

                })
            }
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let content = chatList[selectedRow!]
       let sender = content.sender_id.split(separator: "$")[0]

        if segue.identifier == "OpenChat" {
            let destViewController = segue.destination as! NewMessageChatSectionViewController
            destViewController.receiver = String(sender)
            destViewController.delegate = self
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
        
        return chatList.count

    }
    
    // return the all visible rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatRowCell = tableView.dequeueReusableCell(withIdentifier: "chatRowCell", for: indexPath) as! ChatRowCell
        
        let content = chatList[indexPath.row]
        
        cell.userNameLabel.text = content.name
        let senderID = content.sender_id.split(separator: "$")
        let finalsender = senderID[0]
        Model.instance.getStudentById(id: String(finalsender)) { (student) in
            if (student != nil) {
                // get image only for visible rows
                if(student!.imageUrl != nil && student!.imageUrl != ""){
                    Model.instance.getImage(urlStr: student!.imageUrl! , callback: { (image) in
                            cell.profilePicture.image = image
                    })
                }
            }
        };

        return cell
        
        
    }
    
    // select row event
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selectedRow = indexPath.row
        performSegue(withIdentifier: "OpenChat", sender: (Any).self)

    }

    
}
