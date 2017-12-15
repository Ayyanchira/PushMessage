//
//  EnrolledStudiesTableViewController.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 12/14/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import Alamofire

class EnrolledStudiesTableViewController: UITableViewController {

    var studyList:[Study] = []
    var messageList:[Message] = []
    var surveyList:[Survey] = []
    struct Study:Codable {
        let studyid:Int
        let name:String
        let description:String
    }
    
    struct StudyResponse:Codable {
        let code:Int
        let studies:[Study]?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchStudies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchStudies()
    }
    
    func fetchStudies() {
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "cacced53-8746-cce9-2ecc-1b589728f83c"
        ]
        let token = UserDefaults.standard.object(forKey: "authToken") as! String
        let parameters = ["token": token]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/getStudiesForPatientapi")! as URL,
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
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                do{
                    let studyResponse = try JSONDecoder().decode(StudyResponse.self, from: data!)
                    self.studyList = studyResponse.studies!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        })
        dataTask.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if studyList.count > 0 {
            return 1
        }else{
        return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studyList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyCell", for: indexPath)
        let study = studyList[indexPath.row]
        cell.textLabel?.text = study.name
        cell.detailTextLabel?.text = study.description

        // Configure the cell...

        return cell
    }
 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Withdraw") { (action, indexPath) in
            // delete item at indexPath
//            self.tableArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            print(self.tableArray)
            self.withdrawStudyID(studyID: self.studyList[indexPath.row].studyid)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
        
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studyid = studyList[indexPath.row].studyid
        //fetchMessages
        fetchMessages(studyID: studyid)
        
        //fetchSurveyList
    }

    func withdrawStudyID(studyID:Int){
        let token = UserDefaults.standard.object(forKey: "authToken") as! String
        var parameters = [
            "token" : token,
            "studyid" : "\(studyID)"
        ]
        
        Alamofire.request("http://18.217.3.86:5000/withdrawfromstudyapi", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
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
            
            print("reached here")
            DispatchQueue.main.async {
                
                self.fetchStudies()
            }
            
        }
    }
    
    func fetchMessages(studyID:Int) {
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "cacced53-8746-cce9-2ecc-1b589728f83c"
        ]
        let token = UserDefaults.standard.object(forKey: "authToken") as! String
        let parameters = ["token": token,
                          "studyid":"\(studyID)"]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/getmessagesforpatientapi")! as URL,
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
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                do{
                    let messageResponse = try JSONDecoder().decode(MessageListResponse.self, from: data!)
                    self.messageList = messageResponse.messages!
                    self.fetchSurveyList(studyID: studyID)
                    //fetch surveylist
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        })
        dataTask.resume()
    }
    
    func fetchSurveyList(studyID:Int){
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "cacced53-8746-cce9-2ecc-1b589728f83c"
        ]
        let token = UserDefaults.standard.object(forKey: "authToken") as! String
        let parameters = ["token": token,
                          "studyid":"\(studyID)"]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/getsurveysforpatientapi")! as URL,
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
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                do{
                    let surveyListResponse = try JSONDecoder().decode(SurveyListResponse.self, from: data!)
                    self.surveyList = surveyListResponse.surveys!
                    print("No problem till fetching messages and survey list")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "studyDetails", sender: nil)
                    }
                    
                    
                    //go to next view controller
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        })
        dataTask.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var studyDetailVC = segue.destination as? StudyDetailViewController
        studyDetailVC?.messageList = self.messageList
        studyDetailVC?.surveyList = self.surveyList
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 

}
