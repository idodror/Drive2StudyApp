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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatModel.getAllChatByReceiveIdObserve(receiveName: Model.studentCurrent.userName)
        ModelNotification.ChatList.observe { (list) in
            if list != nil {
                self.chatList = list!
                self.tableView.reloadData()
            }
        }
        
        ModelNotification.ImgURL.observe { (url) in
            if url != nil && url != "" {
                Model.instance.getImage(urlStr: url! , callback: { (image) in
                    //TODO: parsing the url and get the userName
                    // update the image url per userName
                    print("Url: \(url!)")
                    var urltemp = url!
                    urltemp.removeSubrange(urltemp.startIndex..<urltemp.index(urltemp.startIndex, offsetBy: 84))
                    var str = urltemp.split(separator: "?")
                    var userName = str[0]
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
        // performSegue(withIdentifier: "OpenChat", sender: (Any).self)
    }
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let content = chatList[selectedRow!]
        //let sender = content.sender_id
        //to check
        let sender = "idodror10@gmail.com"
        if segue.identifier == "openChat" {
            let destViewController = segue.destination as! NewMessageChatSectionViewController
            destViewController.receiver = sender
            destViewController.delegate = self
        }
    }*/
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatRowCell = tableView.dequeueReusableCell(withIdentifier: "chatRowCell", for: indexPath) as! ChatRowCell
        
        let content = chatList[indexPath.row]
        
        cell.userNameLabel.text = content.sender_id
        Model.instance.getStudentById(id: content.sender_id) { (student) in
            if (student != nil) {
                if(student!.imageUrl != nil && student!.imageUrl != ""){
                    Model.instance.getImage(urlStr: student!.imageUrl! , callback: { (image) in
                            cell.profilePicture.image = image
                    })
                }
            }
        };


        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatItem = chatList[indexPath.row]
            ChatModel.RemoveMessage(chat: chatItem)
            
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selectedRow = indexPath.row
        //performSegue(withIdentifier: "showDetails", sender: self)
    }

    @IBAction func enterChatButtonPressed(_ sender: UIButton) {
               performSegue(withIdentifier: "OpenChat", sender: (Any).self)
    }
}
