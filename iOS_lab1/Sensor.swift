//
//  Sensor.swift
//  iOS_lab1
//
//  Created by Admin on 12/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import os.log

class Sensor {//: NSObject, NSCoding {
    var name: String
    var desc: String
    
    init (name: String, description: String) {
        self.name = name
        self.desc = description
    }
    
    struct PropertyKey {
        static let name = "name"
        static let desc = "desc"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(desc, forKey: PropertyKey.desc)
    }
    
//    required convenience init? (coder aDecoder: NSCoder) {
//        
//    }
}


