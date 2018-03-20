//
//  ChatController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/10/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref = Database.database().reference()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var posts = [Message]()
    
    // send msgs, post to DB
    override func viewDidLoad() {
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let message = Message(text: dictionary["text"] as! String)
                
                self.posts.append(message)
            }
        
            self.chatTableView.reloadData()
        })
    }
    
    @IBAction func handlePostMessage(_ sender: Any) {
        ref.child("Posts").childByAutoId().updateChildValues(["text" : messageTextField.text ?? "nothing"])
        messageTextField.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "messageCell")
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = posts[indexPath.row].text
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
