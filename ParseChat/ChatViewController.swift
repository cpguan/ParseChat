//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Pan Guan on 2/23/17.
//  Copyright © 2017 Pan Guan. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var chatButton: UIButton!
   
    
    var messages: [PFObject]! = []
    var user: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatButtonClick(_ sender: Any) {
        if let userMessage = textField.text {
            if (userMessage.characters.count > 0) {
                let message = PFObject(className: "Message")
                message["text"] = userMessage
                message["user"] = PFUser.current()
                
                message.saveInBackground(block: { (success: Bool, error: Error?) in
                    if !success {
                        print(error!.localizedDescription)
                    }
                    else {
                        self.textField.text = ""
                    }
                })
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row]["text"] as! String?
        if let user = messages[indexPath.row]["user"] as? PFUser {
            if let username = user.username {
                cell.usernameLabel.text = username
            }
        }
            
        else {
            cell.usernameLabel.text = ""
        }
        
        cell.usernameLabel.sizeToFit()
        return cell
    }
    
    func onTimer() {
        
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
               
                self.messages = []
                for obj in objects! {
                    if (obj["text"]) != nil && (obj["text"] as! String).characters.count > 0 {
                        self.messages.append(obj)
                    }
                }
                self.messages = objects!
                self.tableView.reloadData()
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
