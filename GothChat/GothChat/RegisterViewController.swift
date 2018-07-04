//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (authResult,error) in
            if error != nil{
                print("Error in creating user \(String(describing: error))")
            } else {
                self.finishRegistering()
            }
        }
        
    } 
    
    func finishRegistering() {
        print("Finished Registering for \(emailTextfield.text!)")
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    
}
