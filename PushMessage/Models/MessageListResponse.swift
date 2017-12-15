//
//  MessageListResponse.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 12/14/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import Foundation

struct MessageListResponse:Codable {
    let code:Int
    let messages:[Message]?
}

struct Message:Codable {
    let messageid:Int
    let name:String
    let description:String
    let type:String
    let studyid:Int
    let userid:Int
}
