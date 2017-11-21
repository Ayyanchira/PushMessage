//
//  User.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 11/21/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import Foundation

class User: NSObject {
    var name:String
    var age:Int
    var gender:String
    var emailID:String
    
    init(name:String, age:Int, gender:String, emailID:String) {
        self.name = name
        self.age = age
        self.gender = gender
        self.emailID = emailID
    }
    
}
