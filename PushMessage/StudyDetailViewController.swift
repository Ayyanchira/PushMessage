//
//  StudyDetailViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 12/14/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit

class StudyDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var messageList:[Message]?
    var surveyList:[Survey]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(messageList!.count + surveyList!.count)
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageSurveyTogglePressed(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0{
            return messageList!.count
        }else{
            return surveyList!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "cellBasic", for: indexPath)
        
        //Messages
        if segmentControl.selectedSegmentIndex == 0 {
            //cell.textLabel?.text = messageList![indexPath.row].name
            switch messageList![indexPath.row].type{
            case "Informational","Reminder":
                print("hi")
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellBasic", for: indexPath) as! MessageTextTableViewCell
                cell.messageTextView.text = messageList![indexPath.row].name
                return cell
            case "Yes/No":
                print("Hi")
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionaireMessageTableViewCell
                cell.messageTextView.text = messageList![indexPath.row].name
                cell.yesButton.tag = messageList![indexPath.row].studyid
                cell.noButton.tag = messageList![indexPath.row].studyid
                return cell
           
                
            default:
                print("something went wrong in message list")
            }
            
            
        }
        else{
        //Surveys
            let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath) as! SurveyTableViewCell
            cell.surveyTextView.text = surveyList![indexPath.row].description
            cell.takeSurveyButton.tag = surveyList![indexPath.row].surveyid
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
    }

    @IBAction func noButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func takeSurveyButtonPressed(_ sender: UIButton) {
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
