//
//  AttendanceController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/21/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class AttendanceController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    var dates : [String] = []
    let ref = Database.database().reference()
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    let locationManager = CLLocationManager()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        
        ref.child("Rehearsals").observe(DataEventType.childAdded, with: { (snapshot) in
            
            let rehearsal = snapshot.key
            self.dates.append(rehearsal)
            self.myTableView.reloadData()
            
        })
        
        initLocationManager()
        
    }
    
    func initLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("loc changed")
        let mostRecentCLLocation = locations.last!
        latitude = mostRecentCLLocation.coordinate.latitude
        longitude = mostRecentCLLocation.coordinate.longitude
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "", message: "Select one.", preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "Check In!", style: .default) { (alert: UIAlertAction!) -> Void in
            
            let key = self.dates[indexPath.row]
            
            self.ref.child("Rehearsals").child(key).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    
                    let lat = dictionary["lat"] as! String
                    let lon = dictionary["lon"] as! String
                    let dateTime = dictionary["dateTime"] as! Double
                    
                    let rehearsalTime = Date(timeIntervalSince1970: dateTime )
                    let timeDifference = Int(rehearsalTime.timeIntervalSinceNow) / 60
                    
                    //negative means minutes late
                    if (lat == String(self.latitude!) && lon == String(self.longitude!)) {
                        checkTime(timeDifference, key)
                    }
                    else {
                        print("out of range")
                    }
                    

                }
            }
            
        }
        
        func checkTime(_ timeDifference : Int, _ key : String) {
            let userID = Auth.auth().currentUser!.uid
            if (timeDifference >= -10 && timeDifference <= 10) {
                //between 10 mins early and 10 mins late you can check in normal
                print("normal")
                let values = ["status" : "present"]
                self.ref.child("Rehearsals").child(key).child("Attendance").child(userID).updateChildValues(values)
                
            }
            else if (timeDifference > 10) {
                // check in closed.. too early
                print("too early")
            }
            else if (timeDifference < -10 && timeDifference >= -30) {
                // late
                print("late")
                let values = ["status" : "late"]
                self.ref.child("Rehearsals").child(key).child("Attendance").child(userID).updateChildValues(values)
            }
            else {
                // check in closed.. too late
                print("closed late")
            }
        }
        
        let secondAction = UIAlertAction(title: "View Attendance", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("pressed view attendance")
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        present(alert, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dateCell")
        cell.textLabel?.text = String(dates[(indexPath as NSIndexPath).row])
        
        return cell
    }
}
