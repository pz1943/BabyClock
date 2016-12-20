//
//  Record.swift
//  BabyClock
//
//  Created by pz1943 on 2016/12/14.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import Foundation


enum Event: String {
    case WakeUp = "醒来"
    case FallAsleep = "入睡"
    case eat = "吃奶"
    case pop = "臭臭"
}

struct Record {
    var ID: Int
    var event: Event
    var eventName: String {
        return event.rawValue
    }
    var time: Date
    let monthFormatter = DateFormatter()
    let dayFormatter = DateFormatter()
    let hourAndMinuteFormatter = DateFormatter()
    
    var DB = RecordDB()
    
    init(ID: Int, event: Event, time: Date) {
        monthFormatter.dateFormat = "MM"
        dayFormatter.dateFormat = "dd"
        hourAndMinuteFormatter.dateFormat = "HH:mm"
        monthFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dayFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        hourAndMinuteFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        self.ID = ID
        self.event = event
        self.time = time
    }
    
    init(ID: Int, eventName: String, time: Date) {
        monthFormatter.dateFormat = "MM"
        dayFormatter.dateFormat = "dd"
        hourAndMinuteFormatter.dateFormat = "HH:mm"
        monthFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dayFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        hourAndMinuteFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        self.ID = ID
        //FIXME:
        self.event = Event(rawValue: eventName)!
        self.time = time
    }
    
    init(eventName: String) {
        self.ID = Int.allZeros
        
        //FIXME: when eventName was wrong!
        self.event = Event(rawValue: eventName)!
        self.time = Date()
    }
    
    var descTime: String {
        if let prevRecord = loadPreviousRecordOfSameEvent() {
            let timeInterval = time.timeIntervalSince(prevRecord.time)
            return secondsToHourAndMinute(timeInterval: timeInterval)
        } else {
            return "无"
        }
    }
    
    var timeIntervalTillNow: String {
        let seconds = -time.timeIntervalSinceNow
        return secondsToHourAndMinute(timeInterval: seconds)
    }
    
    private func secondsToHourAndMinute(timeInterval: Double) -> String {
        if timeInterval < 86400 {
            var hours = Int(timeInterval / 3600).description
            var minutes = Int(Int(timeInterval) % 3600 / 60).description
            if (hours as NSString).length == 1 { hours = "0" + hours}
            if (minutes as NSString).length == 1 { minutes = "0" + minutes}

            return hours + ":" + minutes
        } else {
            return Int(timeInterval/86400).description + "天"
        }
    }
    
    var timeIntervalTillNowWithoutColon: String {
        let seconds = -time.timeIntervalSinceNow
        return secondsToHourAndMinuteWithoutColon(timeInterval: seconds)
    }
    
    private func secondsToHourAndMinuteWithoutColon(timeInterval: Double) -> String {
        if timeInterval < 86400 {
            var hours = Int(timeInterval / 3600).description
            var minutes = Int(Int(timeInterval) % 3600 / 60).description
            if (hours as NSString).length == 1 { hours = "0" + hours}
            if (minutes as NSString).length == 1 { minutes = "0" + minutes}
            
            return hours + " " + minutes
        } else {
            return Int(timeInterval/86400).description + "天"
        }
    }

    
    var description: String {
        get {
            switch event {
            case .FallAsleep: return "共清醒"
            case .WakeUp: return "共睡眠"
            case .eat: return "间隔"
            case .pop: return "间隔"
            }
        }
    }
    var monthAndDay: String {
        get {
            let month: String = monthFormatter.string(from: time)
            let day: String = dayFormatter.string(from: time)
            let dayOfToday: String = dayFormatter.string(from: Date())
            if time.timeIntervalSinceNow > -172800 {
                if day == dayOfToday {
                    return "今天"
                } else if let x = Int(dayOfToday) {
                    if let y = Int(day) {
                        if x - 1 == y {
                            return "昨天"
                        }
                    }
                }
            }
            return month + "月" + day + "日"
        }
    }
    
    var hourAndMinute: String {
        get {
            return hourAndMinuteFormatter.string(from: time)
        }
    }
    

    
    func loadPreviousRecordOfSameEvent() -> Record? {
        let preEvent: Event
        switch event {
        case .FallAsleep: preEvent = Event.WakeUp
        case .WakeUp: preEvent = Event.FallAsleep
        default: preEvent = event
        }
        return DB.loadRecordOfEventNextToID(event: preEvent, ID: ID)
    }
    
}
