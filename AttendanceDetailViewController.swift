//
//  AttendanceDetailViewController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/22/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit
import Firebase

class AttendanceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = Database.database().reference()
    @IBOutlet weak var myTableView: UITableView!
    var attendees : [String] = []
    var attendanceDict : [String : String] = [:]
    var key : String?
    
    override func viewDidLoad() {
        // make api call to get users names from AttendanceList
        
        ref.child("Rehearsals").child(key!).child("Attendance").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let status = dictionary["status"] as! String
                
                let uid = snapshot.key
                self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject] {
                        let userInfo = dictionary[uid] as! [String : AnyObject]
                        let name = userInfo["name"] as! String
                        
                        self.attendees.append(name)
                        self.attendanceDict[name] = status
                        
                        self.myTableView.reloadData()
                    }
                    
                })
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return attendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "attendanceCell")
        let name = attendees[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = attendanceDict[name]
        
        return cell
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
