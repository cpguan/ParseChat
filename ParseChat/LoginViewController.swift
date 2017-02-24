//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Pan Guan on 2/22/17.
//  Copyright © 2017 Pan Guan. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

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
    

    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                
            } else {
                self.performSegue(withIdentifier: "success", sender: nil)
            }
        }
    }
    
    
    @IBAction func onLogIn(_ sender: Any) {
        
       let username = emailTextField.text
       let password = passwordTextField.text
    
    
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user: PFUser?, error: Error?) in
            
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                // create a cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                   
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
            else {
                self.performSegue(withIdentifier: "success", sender: nil)
            
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination.childViewControllers[0] as! ChatViewController
        destination.user = emailTextField.text!
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
