//
//  ViewController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/6/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    // 28,181,224
    // 22,134,166
    let primaryColor = UIColor(red: 28/255, green: 181/255, blue: 224/255, alpha: 1)
    let secondaryColor = UIColor(red: 22/255, green: 134/255, blue: 166/255, alpha: 1)
    
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accessCodeTextField: UITextField!
    
    @IBOutlet weak var segCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        LoginButton.layer.cornerRadius = 5
        LoginButton.backgroundColor = UIColor.gray
        passwordTextField.isSecureTextEntry = true
        nameTextField.isHidden = true
        accessCodeTextField.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            performSegue(withIdentifier: "Segue to home", sender: Auth.auth().currentUser?.uid)
            print("user already signed in")
        }
    }
    
    @IBAction func handleLoginRegisterChange(_ sender: Any) {
        LoginButton.setTitle(segCtrl.titleForSegment(at: segCtrl.selectedSegmentIndex), for: .normal)
        if nameTextField.isHidden == true {
            nameTextField.isHidden = false
            accessCodeTextField.isHidden = false
        }
        else {
            nameTextField.isHidden = true
            accessCodeTextField.isHidden = true
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print ("missing email or pass")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                print("signed in!")
                self.performSegue(withIdentifier: "Segue to home", sender: " ")
            }
        }
    }
    
    
    @IBAction func handleLoginRegister(_ sender: Any) {
        segCtrl.selectedSegmentIndex == 0 ? handleLogin() : handleRegister()
    }
    
    
    func handleRegister() {

        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print ("missing email, pass, or name")
            return
        }
        
        let code = accessCodeTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            if error != nil {
                print("Error is: \(error!.localizedDescription)")
            }
            else {
                print("registered new user")
            }

            guard let uid = user?.uid else {
                return
            }

            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email, "code" : code]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in

                if let err = err {
                    print(err)
                    return
                }
                self.performSegue(withIdentifier: "Segue to home", sender: " ")
                print("Saved user successfully into Firebase db")

            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue to home" {
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //handleSend()
        return true
    }
}

