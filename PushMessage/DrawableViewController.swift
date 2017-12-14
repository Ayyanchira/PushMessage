//
//  DrawableViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 11/16/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import Alamofire

class DrawableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menuOptions = ["Enrolled Studies","Profile", "Logout"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sidebarCustomCell", for: indexPath) as! SidebarCustomTableViewCell
        cell.titleLabel.text = menuOptions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let container = self.so_containerViewController {
            
            let navControl = container.topViewController as! UINavigationController
            if indexPath.row == 0{
                navControl.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier: "EnrolledStudyView"))!], animated: false)
            }else if indexPath.row == 1{
                //var hamButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: <#T##Selector?#>)
                
                //navControl.setToolbarItems([hamButton], animated: false)
                navControl.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier: "profileVC"))!], animated: false)
            }else if indexPath.row == 2{
                performLogout()
                container.dismiss(animated: true, completion: nil)
            }
            
            container.isSideViewControllerPresented = false
        }
        
        //let messageVC = navControl.topViewController! as! MessagesViewController
        
       // so_containerViewController?.topViewController?.performSegue(withIdentifier: "profileView", sender: nil)
    }

    
    func performLogout() {
        let token = UserDefaults.standard.object(forKey: "authToken")
        let parameters = [
            "token" : token!
        ]
        Alamofire.request("http://18.217.3.86:5000/patientlogoutapi", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            //error checking
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /todos/1")
                print(response.result.error!)
                return
            }
            
            //response check
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get formatted JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            if json["code"] as? Int == 200{
                self.so_containerViewController?.dismiss(animated: true, completion: nil)
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
