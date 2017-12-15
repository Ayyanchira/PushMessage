//
//  StudyDetailViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 12/14/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import ResearchKit

class StudyDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, ORKTaskViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var messageList:[Message]?
    var surveyList:[Survey]?
    var questions:[Questions] = []
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellBasic", for: indexPath) as! MessageTextTableViewCell
                cell.messageTextView.text = messageList![indexPath.row].name
                return cell
            case "Yes/No":
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
        var selectedButton = "Yes"
        if sender.titleLabel?.text == "No" {
            selectedButton = "No"
        }
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "9a1acc2b-8b92-9244-4e64-c4e8525e8870"
        ]
        let parameters = [
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXRpZW50aWQiOjcsIm5hbWUiOiJwYXRpZW50MSIsImVtYWlsIjoicGF0aWVudDFAZ21haWwuY29tIiwiYWdlIjoiMjIiLCJnZW5kZXIiOiJNYWxlIiwiaWF0IjoxNTEzMjg3MTQ5fQ.8cHXlx2ymas8k8GhgB5zItDBIE8PzuhCLYi5kbIfguw",
            "messageid": "\(sender.tag)",
            "answer": selectedButton
            ] as [String : Any]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/sendmessageanswerapi")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    let surveyResponse = try JSONDecoder().decode(MessageSubmitResponse.self, from: data!)
                    if surveyResponse.code == 200{
                        let alert = UIAlertController(title: "Success", message: "Thank you responding", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Failure", message: "You have already submitted the response for this question", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    //add the responded id to array
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
    }

    
    @IBAction func takeSurveyButtonPressed(_ sender: UIButton) {
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "03cd4a87-9c9b-610f-2e7d-d0b43ddc4c9b"
        ]
         let token = UserDefaults.standard.object(forKey: "authToken") as! String
        let parameters = [
            "token": token,
            "surveyid": "\(sender.tag)"
            ] as [String : Any]
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/getsquestionsforsurveyapi")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    let surveyResponse = try JSONDecoder().decode(SurveyResponse.self, from: data!)
                    let surveyTask = SurveyTask()
                    
                    DispatchQueue.main.async {
                        let taskViewController = ORKTaskViewController(task: surveyTask.getOrderedTasksWithRulesWith(surveyID: sender.tag, questionList: surveyResponse.questions), taskRun: nil)
                        taskViewController.delegate = self
                        self.questions = surveyResponse.questions
                        self.present(taskViewController, animated: true, completion: nil)
                    }
                    
                    print("Got survey question")
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        print("Survey Completed")
        
        if reason == ORKTaskViewControllerFinishReason.discarded || reason == ORKTaskViewControllerFinishReason.failed{
            taskViewController.dismiss(animated: true, completion: nil)
            return
        }
        var answers:[[String:Any]] = []
        for question in self.questions{
            var answerString = ""
            if let stepResult = taskViewController.result.stepResult(forStepIdentifier:"\(question.questionid)"){
                var results = stepResult.results
                switch question.type{
                case "likert":
                    let scaleAnswer = results![0] as! ORKScaleQuestionResult
                    if let answer = scaleAnswer.scaleAnswer as? Int{
                       answerString = "\(answer)"
                    }else{
                        answerString = "NA"
                    }
                    
                    
                case "multiple":
                    let scaleAnswer = results![0] as! ORKChoiceQuestionResult
                    if let answer = scaleAnswer.choiceAnswers{
                        answerString = "\(answer[0] as! Int)"
                    }else{
                        answerString = "NA"
                    }
                    
                    
                case "text":
                    let textAnswer = results![0] as! ORKTextQuestionResult
                    if let answer = textAnswer.textAnswer{
                        answerString = answer
                    }else{
                        answerString = "NA"
                    }
                    
                default:
                    print("Default case executed")
                    
                }
                
                let surveyObject = ["questionid":"\(question.questionid)",
                "answer": answerString]
                answers.append(surveyObject)
            }
                
        }
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "f14d778a-405e-c65f-72e4-e69deec852d5"
        ]
        let token = UserDefaults.standard.object(forKey: "authToken") as! String
        let parameters = [
            "token": token,
            "answers": answers
            ] as [String : Any]
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/sendanswerapi")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    let respo = try JSONDecoder().decode(SubmitSurveyResponse.self, from: data!)
                    print("Finally done")
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
        
        taskViewController.dismiss(animated: true, completion: nil)
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

struct SurveyAnswer:Codable {
    let questionid:String
    let answer:String
    
//    init(questionID:String, answer:String) {
//        self.questionid = questionID
//        self.answer = answer
//    }
}

struct SubmitSurveyResponse:Codable {
    let code:Int
    let status:String
}
