//
//  TimeInterval.swift
//  BabyClock
//
//  Created by pz1943 on 2017/1/8.
//  Copyright © 2017年 pz1943. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var HAndM: String {
        if self == 0 {
            return "无"
        } else if self < 86400 {
            var hours = Int(self / 3600).description
            var minutes = Int(Int(self) % 3600 / 60).description
            if (hours as NSString).length == 1 { hours = "0" + hours}
            if (minutes as NSString).length == 1 { minutes = "0" + minutes}
            
            return hours + ":" + minutes
        } else {
            return Int(self/86400).description + "天"
        }
    }
    
    var HAndMWithoutColon: String {
        if self < 86400 {
            var hours = Int(self / 3600).description
            var minutes = Int(Int(self) % 3600 / 60).description
            if (hours as NSString).length == 1 { hours = "0" + hours}
            if (minutes as NSString).length == 1 { minutes = "0" + minutes}
            
            return hours + " " + minutes
        } else {
            return Int(self/86400).description + "天"
        }
    }
}
