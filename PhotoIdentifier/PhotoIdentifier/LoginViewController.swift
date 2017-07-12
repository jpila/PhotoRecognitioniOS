//
//  LoginViewController.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-12.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: ViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginAction(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == ""{
            
            let alertController = UIAlertController(title: "Error", message: "Please Enter Username or Password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                if error == nil{
                    print("You have sucessfully logged in ")
                    
                    // go to homeviewcontroller if login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    
                    // Tells the user that there is an error and then gets firebase to tell them
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            })
        }

    }

}
