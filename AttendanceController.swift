//
//  AttendanceController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/21/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit
import Firebase

class AttendanceController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    var dates : [String] = []
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        //dates.append(1)
        ref.child("Rehearsals").observe(DataEventType.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let rehearsal = dictionary["dateTime"] as! String
                
                self.dates.append(rehearsal)
            }
            
            self.myTableView.reloadData()
        })
        
    }
    
//    @IBAction func addDate(_ sender: Any) {
//        let date = dates.count + 1
//
//        dates.append(date)
//
//        self.myTableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dateCell")
        cell.textLabel?.text = String(dates[(indexPath as NSIndexPath).row])
        
        return cell
    }
}
