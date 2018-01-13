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
        
        cell.userNameLabel.text = content.name
        
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
