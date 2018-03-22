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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let ref = Database.database().reference()
        let dateTime = dateFormatter.string(from: startDateTimePicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: startDateTimePicker.date)
        let duration = durationPicker.countDownDuration.description
        
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateFormatterP = DateFormatter()
//        dateFormatterP.dateFormat = "yyyy-MM-dd HH:mm"
//        let datenew: Date? = dateFormatterGet.date(from: date)
//        print(dateFormatterP.string(from: datenew!))
        
        // how do i add the values? what API call
        
        let childRef = ref.child("Rehearsals").child(date)
        let values = ["dateTime": dateTime, "duration" : duration]
        childRef.updateChildValues(values)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
