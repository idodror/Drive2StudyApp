//
//  NewMessageChatSectionViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 28/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth


protocol NewMessageChatSectionViewControllerDelegate {
    
}

class NewMessageChatSectionViewController: JSQMessagesViewController {
    
    var delegate: NewMessageChatSectionViewControllerDelegate?
    var receiver:String = ""
    //Local property to store messages
    var messages = [JSQMessage]()

    
    //checking if user is typing
    private lazy var usersTypingQuery = ChatModelFirebase.refs.databaseChats.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    private lazy var userIsTypingRef =
        ChatModelFirebase.refs.databaseChats.child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.gray)
    }()
    
    lazy var DriveRideBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = Model.studentCurrent.userName
        senderDisplayName = senderId.replacingOccurrences(of: ",", with: ".")
        
        //Hide avatar and attachment button on the left of the chat text input field
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let query = ChatModelFirebase.refs.databaseChats.queryLimited(toLast: 100)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if self != nil {
                if  let data        = snapshot.value as? [String: String],
                    let id          = data["sender_id"],
                    let name        = data["name"],
                    let text        = data["text"],
                    !text.isEmpty {
                    if let message = JSQMessage(senderId: id,displayName: name, text: text) {
                       
                        let temp = message.senderId
                        let str = temp!.split(separator: "$")

                        print("\(str[0])")
                        print("\(str[1])")
                        
                        if(String(str[0]) == self?.senderId && String(str[1]) == self?.receiver) {
                            self?.messages.append(message)
                            self?.finishReceivingMessage()
                        }
                        else if(String(str[0]) == self?.receiver && String(str[1]) == self?.senderId) {
                            self?.messages.append(message)
                            self?.finishReceivingMessage()
                        }
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returning the message data for a particular message by its index
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
     //returns the total number of messages
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }

    //When messages[indexPath.item].senderId == senderId is true, return outgoingBubble else return incomingBubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let sender = messages[indexPath.item].senderId
        let parsedSender = sender?.split(separator: "$")
        let mysender = senderId.split(separator: "$")
        if(messages[indexPath.item].text == "Hi! Can I have a ride to College?" || messages[indexPath.item].text == "Hi! Would you like a ride to College?"){
            return DriveRideBubble
        }
        return parsedSender![0] == mysender[0] ? outgoingBubble : incomingBubble
    }
    
    //Hide avatars for message bubbles
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    //Is called when the label text is needed
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    //Is called when the height of the top label is needed
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    //Sending a chat message
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let ref = ChatModelFirebase.refs.databaseChats.childByAutoId()
        let message = ["sender_id": senderId+"$"+receiver,"receiver_id": receiver, "name": senderDisplayName, "text": text]
        
        ref.setValue(message)
        isTyping = false
        finishSendingMessage()
    }
    
    //Checking if the text changed to show user typing
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        isTyping = textView.text != ""
    }
    
    private func observeTyping() {
        let typingIndicatorRef = ChatModelFirebase.refs.databaseChats.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        
        usersTypingQuery.observe(.value, with: { (snapshot) in
            if ((snapshot.value as? String) != nil){
                
            //You're the only one typing, don't show the indicator
                if snapshot.childrenCount == 1 && (self.isTyping) {
                return
                }
            
            //Are there others typing?
                if (snapshot.childrenCount > 0){
                    self.showTypingIndicator = true
                    self.scrollToBottom(animated: true)
                }
                else{
                    self.showTypingIndicator = false
                }
                
            }
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeTyping()
    }
    
    
}
