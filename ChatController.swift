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
    @IBOutlet weak var postView: UIView!
    
    var posts = [Message]()
    var removedRow = 0
    var hide = true
    
    // send msgs, post to DB
    override func viewDidLoad() {
        postView.isHidden = true
        let user = Auth.auth().currentUser!.uid
        ref.child("users").child(user).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                // change this to check role and hide textfield and button if necessary
                let accessCode = dictionary["code"] as! String
                if (accessCode == "SM_2018") {
                    self.postView.isHidden = false
                }
            }
        }
        
        ref.child("Posts").observe(DataEventType.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let message = Message((dictionary["text"] as! String), (dictionary["user"] as! String), (dictionary["postID"] as! String), (dictionary["timestamp"] as! String))
                
                self.posts.append(message)
            }
        
            self.chatTableView.reloadData()
        })
    }
    
    @IBAction func handlePostMessage(_ sender: Any) {
        let childRef = ref.child("Posts").childByAutoId()
        
        let user = Auth.auth().currentUser
        let postID = childRef.key
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        let newPost = Message(messageTextField.text ?? "nothing", String(describing: user), postID, timestamp)
        
        childRef.updateChildValues(["text" : newPost.text!, "user" : newPost.user!, "postID" : newPost.postID!, "timestamp" : newPost.timestamp!])
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = posts[(indexPath as NSIndexPath).row].postID!
            ref.child("Posts").child(key).removeValue()
            posts.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
           // updatePersistentStorage()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
