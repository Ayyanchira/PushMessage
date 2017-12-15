//
//  SurveyListResponse.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 12/14/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import Foundation

struct SurveyListResponse:Codable {
    let code:Int
    let surveys:[Survey]?
}

struct Survey:Codable {
    let surveyid:Int
    let name:String
    let description:String
    let userid:Int
}

