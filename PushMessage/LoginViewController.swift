//
//  LoginViewController.swift
//  PushMessage
//
//  Created by Akshay Ayyanchira on 11/16/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            login(username: usernameTextField.text!, password: passwordTextField.text!)
        }
        else{
            self.performSegue(withIdentifier: "LoginSuccess", sender: nil)
        }
        
    }
    
    func login(username: String, password:String) {
        
//        var parameters = [
//            "email" : usernameTextField.text!,
//            "password" : passwordTextField.text!,
//        ]
//
//        if let deviceToken = UserDefaults.standard.object(forKey: "deviceToken") as? String{
//            parameters["deviceToken"] = deviceToken
//        }
//        else{
//            parameters["deviceToken"] = "2fc86447001e1e9b97c0cde26e6b875baaf2154a6acbb0573543faffa9c2bd52"
//
//        }
//
//        Alamofire.request("http://18.217.3.86:5000/notifyloginapi", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            //error checking
//            guard response.result.error == nil else {
//                // got an error in getting the data, need to handle it
//                print("error calling GET on /todos/1")
//
//                print(response.result.error!)
//                return
//            }
//
//            //response check
//            guard let json = response.result.value as? [String: Any] else {
//                print("didn't get formatted JSON from API")
//                print("Error: \(String(describing: response.result.error))")
//                return
//            }
//
//            var age = 0
//            var gender = ""
//            var name = ""
//            var authToken = ""
//
//            //username
//            if let ageFromResponse = json["age"] as? Int{
//                age = ageFromResponse
//            }
//            //Username
//            if let username = json["name"] as? String{
//                name = username
//            }
//            //Gender
//            if let genderResponse = json["gender"] as? String{
//                gender = genderResponse
//            }
//            //JWT Token
//            if let token = json["token"] as? String{
//                authToken = token
//            }
            //let user = User(name: name, age: age, gender: gender, emailID: )
            UserDefaults.standard.set("authToken", forKey: "authToken")
            //UserDefaults.standard.set(user, forKey: "userObject")
            UserDefaults.standard.set("name", forKey: "name")
            UserDefaults.standard.set(25, forKey: "age")
            UserDefaults.standard.set("gender", forKey: "gender")
            UserDefaults.standard.set(self.usernameTextField.text!, forKey: "emailID")
            self.performSegue(withIdentifier: "LoginSuccess", sender: nil)
//        }
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
