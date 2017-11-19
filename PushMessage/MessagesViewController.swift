//
//  MessagesViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 11/16/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import Alamofire

class MessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllMessages()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MenuButtonPressed(_ sender: UIBarButtonItem) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath) as! MessageInformationTableViewCell
        
        if indexPath.row == 1{
            cell.infoTextView.text = "The benefits that come with owning a dog are clear-- physical activity, support, companionship -- but owning a dog could literally be saving your life. Dog ownership is associated with a reduced risk for cardiovascular disease and death, finds a new Swedish study published Friday in the journal Scientific Reports."
        }
        else{
            cell.infoTextView.text = "All you need is love. But a little chocolate now and then doesn't hurt."
        }
        
//
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "Hi"
        return cell
    }
    
    
    func getAllMessages() {
        Alamofire.request("http://13.59.54.128:4000/getMessagesForPatient").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
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
