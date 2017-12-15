//
//  SurveyResponse.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 12/14/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import Foundation

struct SurveyResponse:Codable {
    let code:Int
    let questions:[Questions]
}

struct Questions:Codable{
    let questionid:Int
    let question:String
    let type:String
    let surveyid:Int
    let likertscale:String
}
