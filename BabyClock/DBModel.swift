//
//  Created by apple on 15/12/19.
//  Copyright © 2015年 pz1943. All rights reserved.
//

import Foundation
import SQLite

class DBModel {
    static let sharedInstance = DBModel()
    fileprivate var db: Connection

    struct Constants {
        static let inspectionDelayHour: Int = 8
    }
    
    func getDB() -> Connection {
        return self.db
    }
    
    func reload() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
//        print(path)
        db = try! Connection("\(path)/db.sqlite3")
    }
    
    required init() {
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm ss"
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        db = try! Connection("\(path)/db.sqlite3")
    }
}



enum ExpressionTitle:  String, CustomStringConvertible{
    case ID = "ID"
    case EVENTNAME = "事件名称"
    case TIME = "事件时间"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
}


class RecordDB {
    fileprivate var db: Connection
    fileprivate var recordTable: Table
    
    fileprivate let IDExpression = Expression<Int>(ExpressionTitle.ID.description)
    fileprivate let eventNameExpression = Expression<String>(ExpressionTitle.EVENTNAME.description)
    fileprivate let timeExpression = Expression<Date>(ExpressionTitle.TIME.description)
    
    var count: Int {
        get {
            return try! self.db.scalar(recordTable.count)
        }
    }
    
    init() {
        self.db = DBModel.sharedInstance.getDB()
        self.recordTable = Table("recordTable")
        
        try! db.run(recordTable.create(ifNotExists: true) { t in
            t.column(IDExpression, primaryKey: true)
            t.column(eventNameExpression)
            t.column(timeExpression)
        })
    }
    
    var maxID: Int? {
        get {
            return try! db.scalar(recordTable.select(IDExpression.max))
        }
    }
    
    func addRecord(_ record: Record) {
        let insert = recordTable.insert(self.eventNameExpression <- record.eventName, self.timeExpression <- record.time)
        
        do {
            _ = try db.run(insert)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func delRecord(_ ID: Int) {
        let alice = recordTable.filter(self.IDExpression == ID)
        do {
            _ = try db.run(alice.delete())
        } catch let error as NSError {
            print(error)
        }
    }

    func clearRecords() {
        do {
            _ = try db.run(recordTable.delete())
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getRecords() -> [Record]{
        var records: [Record] = []
        let rows = Array(try! db.prepare(recordTable))
        for row in rows {
            let record = Record(ID: row[self.IDExpression], eventName: row[eventNameExpression], time: row[timeExpression])
            records.append(record)
        }
        return records
    }
    
    func loadRecordFromID(_ ID: Int) -> Record {
        let alice = recordTable.filter(self.IDExpression == ID)
        let row = Array(try! db.prepare(alice)).first!
        let record = Record(ID: row[self.IDExpression], eventName: row[eventNameExpression], time: row[timeExpression])
        return record
        
    }
    
    func loadRecordFromIndex(_ index: Int) -> Record? {
        let alice = recordTable.limit(1, offset: count - 1 - index)
        if let row = try! db.pluck(alice) {
            return Record(ID: row[self.IDExpression], eventName: row[eventNameExpression], time: row[timeExpression])
        } else { return nil }
    }
    
    func loadNewestRecord() -> Record? {
        return loadRecordFromIndex(0)
    }
    
    func loadNewestRecordOfEvent (event: Event) -> Record? {
        if let ID = loadNewestRecord()?.ID {
            return loadRecordOfEventNextToID(event: event, ID: ID + 1)
        } else {
            return nil
        }
    }
    
    func loadRecordOfEventNextToID (event: Event, ID: Int) -> Record? {
        for i in (0 ... ID - 1).reversed() {
            let alice = recordTable.filter(IDExpression == i)
            if let row = try! db.pluck(alice) {
                if row[eventNameExpression] == event.rawValue {
                    return Record(ID: row[self.IDExpression], eventName: row[eventNameExpression], time: row[timeExpression])
                }
            }
        }
        return nil
    }
}
