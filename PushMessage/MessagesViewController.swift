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
    
    enum MessageType:String {
        case information = "information"
        case question = "question"
        case survey = "survey"
    }
    
    @IBOutlet var messageTableView: UITableView!
    var allMessages:MessageResponse?
    var respondedMessages:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        respondedMessages.append(2)
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
        return allMessages?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = allMessages?.messages![indexPath.row] else {return UITableViewCell()}
        
        switch message.type {
        case "information":
            let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath) as! MessageInformationTableViewCell
            cell.infoTextView.text = message.message
            return cell
    
        case "question":
            let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath) as! QuestionYesNoTableViewCell
            cell.questionTextView.text = message.message
            cell.rightButton.setTitle("NO", for: .normal)
            cell.rightButton.tag = message.messageid
            cell.leftButton.setTitle("YES", for: .normal)
            cell.leftButton.tag = message.messageid
            if respondedMessages.contains(message.messageid){
                cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.rightButton.isEnabled = false
                cell.leftButton.isEnabled = false
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
        respondedMessages.append(tag)
    }
    @IBAction func questionRightButtonTapped(_ sender: UIButton) {
    }
    
    func getAllMessages() {
        Alamofire.request("http://13.59.54.128:4000/getMessagesForPatient").responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                self.allMessages = MessageResponse(dictionary: json as! NSDictionary)
                self.messageTableView.reloadData()
            }
        }
    }
}
