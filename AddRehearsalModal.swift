//
//  AddRehearsalModal.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/21/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit
import Firebase

class AddRehearsalModal: UIViewController {
    
    @IBOutlet weak var startDateTimePicker: UIDatePicker!
    @IBOutlet weak var durationPicker: UIDatePicker!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }

    @IBAction func addRehearsal(_ sender: Any) {
        
        // Add these times to Firebase as children under rehearsals node
        let ref = Database.database().reference()
        let dateTime = Double(startDateTimePicker.date.timeIntervalSince1970)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let key = dateFormatter.string(from: startDateTimePicker.date)
        let duration = durationPicker.countDownDuration.description

        
        let childRef = ref.child("Rehearsals").child(key)
        let values = ["dateTime": dateTime, "duration" : duration, "lat" : "37.785834", "lon" : "-122.406417"] as [String : Any]
        childRef.updateChildValues(values)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
