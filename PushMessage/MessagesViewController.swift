//
//  MessagesViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 11/16/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import Alamofire
import NotificationCenter

class MessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum MessageType:String {
        case information = "information"
        case question = "Yes/No"
        case survey = "survey"
    }
    let myNotification = Notification.Name(rawValue:"MyNotification")
    @IBOutlet var messageTableView: UITableView!
    var allMessages:MessageResponse?
    //var respondedMessages:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //respondedMessages.append(2)
        getAllMessages()
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // getAllMessages()
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
        return allMessages?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = allMessages?.messages![indexPath.row] else {return UITableViewCell()}
        
        switch message.type {
        case "Information":
            let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath) as! MessageInformationTableViewCell
            cell.infoTextView.text = message.message
            return cell
    
        case "Yes/No":
            let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath) as! QuestionYesNoTableViewCell
            cell.questionTextView.text = message.message
            cell.rightButton.setTitle("NO", for: .normal)
            cell.rightButton.tag = message.id
            cell.leftButton.setTitle("YES", for: .normal)
            cell.leftButton.tag = message.id
            if message.answer != nil{
//            if respondedMessages.contains(message.id){
                cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.rightButton.isEnabled = false
                cell.leftButton.isEnabled = false
                if message.answer == "YES"{
                    cell.leftButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .disabled)
                    cell.rightButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
                }else{
                    cell.leftButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
                    cell.rightButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .disabled)
                }
                
            }
            
            return cell
            
            // case "survey":
            
        default:
            return UITableViewCell()
        }
        
//        if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath) as! MessageInformationTableViewCell
//            cell.infoTextView.text = "The benefits that come with owning a dog are clear-- physical activity, support, companionship -- but owning a dog could literally be saving your life. Dog ownership is associated with a reduced risk for cardiovascular disease and death, finds a new Swedish study published Friday in the journal Scientific Reports."
//            return cell
//        }
//        else if indexPath.row == 0 || indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath) as! MessageInformationTableViewCell
//            cell.infoTextView.text = "All you need is love. But a little chocolate now and then doesn't hurt."
//            return cell
//        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath) as! QuestionYesNoTableViewCell
//            cell.questionTextView.text = "The benefits that come with owning a dog are clear-- physical activity, support, companionship -- but owning a dog could literally be saving your life. Dog ownership is associated with a reduced risk for cardiovascular disease and death, finds a new Swedish study published Friday in the journal Scientific Reports."
//            return cell
//        }
    }
    
    @IBAction func questionLeftButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        //respondedMessages.append(tag)
        let parameter = [
            "token" : UserDefaults.standard.object(forKey: "authToken"),
            "messageid" : tag,
            "answer" : "YES"
        ]
        Alamofire.request("http://18.217.3.86:5000/notifyanswerapi", method: HTTPMethod.post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            self.getAllMessages()
        }
        
    }
    @IBAction func questionRightButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        //respondedMessages.append(tag)
        let parameter = [
            "token" : UserDefaults.standard.object(forKey: "authToken"),
            "messageid" : tag,
            "answer" : "NO"
        ]
        Alamofire.request("http://18.217.3.86:5000/notifyanswerapi", method: HTTPMethod.post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            self.getAllMessages()
        }
    
    }
    
    func getAllMessages() {
        
        if let token = UserDefaults.standard.object(forKey: "authToken") as? String{
            let parameter = [
                "token" : token
            ]
            Alamofire.request("http://18.217.3.86:5000/getmessagesapi", method: HTTPMethod.post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                if let json = response.result.value as? [String:Any]{
                    print("JSON: \(json)") // serialized json response
                    let code = json["code"] as? Int
                    if code == 200{
                        let messagesResponses = ["messages": json["result"]]
                        //let messageResponses =  as! NSDictionary
                        self.allMessages = MessageResponse(dictionary: messagesResponses as NSDictionary)
                        self.messageTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        getAllMessages()
        
    }
    
}
