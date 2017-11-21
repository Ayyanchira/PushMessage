//
//  ProfileViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 11/16/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let age = UserDefaults.standard.object(forKey: "age") as? Int
        nameLabel.text = UserDefaults.standard.object(forKey: "name") as? String
        ageLabel.text = "\(age!)"
        emailLabel.text = UserDefaults.standard.object(forKey: "emailID") as? String
        genderLabel.text = UserDefaults.standard.object(forKey: "gender") as? String
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            notificationSwitch.setOn(true, animated: true)
        } else {
            notificationSwitch.setOn(false, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        if sender.isOn{
            UIApplication.shared.registerForRemoteNotifications()
        }
        else{
            UIApplication.shared.registerForRemoteNotifications()
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
