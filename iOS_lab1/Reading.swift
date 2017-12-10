//
//  Reading.swift
//  iOS_lab1
//
//  Created by Admin on 12/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class Reading {
    var timestamp: Double
    var sensors: [Sensor]
    var value: Double
    
    init(timestamp: Double, sensors: [Sensor], value: Double) {
        self.timestamp = timestamp
        self.sensors = sensors
        self.value = value
    }
}
