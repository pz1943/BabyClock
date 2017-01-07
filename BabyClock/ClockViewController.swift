//
//  ClockViewController.swift
//  BabyClock
//
//  Created by pz1943 on 2016/12/12.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import UIKit
import SQLite

class ClockViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture() 
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ClockViewController.timer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        setPieChart()
    }

    private func setPieChart() {
        clockView.backgroundColor = UIColor.white
        clockView.translatesAutoresizingMaskIntoConstraints = false
        clockView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.view.addSubview(clockView)
        
        let left = NSLayoutConstraint(item: clockView, attribute: .leading, relatedBy: .equal, toItem: chartsContainer, attribute: .leadingMargin, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: clockView, attribute: .trailing , relatedBy: .equal, toItem: chartsContainer, attribute: .trailingMargin, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: clockView, attribute: .top , relatedBy: .equal, toItem: chartsContainer, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: clockView, attribute: .bottom, relatedBy: .equal, toItem: chartsContainer, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([left, right, top, bottom])

        
        let date = Date(timeIntervalSinceNow: -50000)
        let records = DB.loadRecordsOfDay(date: date)
        let data = loadClockChartDate(records: records)
        clockView.chartDate = data
    }
    
    private func loadClockChartDate(records: [Record]) -> [ClockChartData] {
        var dates: [ClockChartData] = []
        for record in records {
            if let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: record.time) {
                if record.time < noon{
                    switch record.event {
                    case .eat:
                        let color = UIColor.green
                        let begin: Date = record.time
                        let end: Date = Date(timeInterval: 600, since: begin)
                        dates.append(ClockChartData(begin: begin, end: end, color: color))
                    case .FallAsleep:
                        let color = UIColor.orange
                        if let begin: Date = record.loadPreviousRecordOfSameEvent()?.time {
                            let end: Date = record.time
                            dates.append(ClockChartData(begin: begin, end: end, color: color))
                        }
                    case .WakeUp:
                        let color = UIColor.cyan
                        if let begin: Date = record.loadPreviousRecordOfSameEvent()?.time {
                            let end: Date = record.time
                            dates.append(ClockChartData(begin: begin, end: end, color: color))
                        }
                    case .pop:
                        let color = UIColor.red
                        let begin: Date = record.time
                        let end: Date = Date(timeInterval: 120, since: begin)
                        dates.append(ClockChartData(begin: begin, end: end, color: color))
                    default: break
                    }
                }
            }
        }
        return dates
    }
    override func viewWillAppear(_ animated: Bool) {
        loadCurState()
        stateChange()
        refreshIntervalTime();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var DB: RecordDB = RecordDB()
    var newestRecord: Record?
    var curState: String = "空白"
    var colonFlag: Bool = false
    var longPressedEvent: Event?
    var clockView: PzClockChartView = PzClockChartView()
    
    @IBOutlet weak var chartsContainer: UIView!
    @IBOutlet weak var sleepInterval: UILabel!
    @IBOutlet weak var weakupInterval: UILabel!
    @IBOutlet weak var eatInterval: UILabel!
    @IBOutlet weak var popInterval: UILabel!
    
    @IBOutlet weak var sleepTime: UILabel!
    @IBOutlet weak var weakUpTime: UILabel!
    @IBOutlet weak var eatTime: UILabel!
    @IBOutlet weak var popTime: UILabel!
    
    @IBOutlet weak var weakUpState: UILabel!
    @IBOutlet weak var sleepState: UILabel!
    
    //--------------------------------------
    //buttons

    @IBOutlet weak var pop: UIButton!
    @IBOutlet weak var eat: UIButton!
    @IBOutlet weak var wakeUp: UIButton!
    @IBOutlet weak var goSleep: UIButton!
    
    @IBAction func goSleep(_ sender: UIButton) {
        if curState != "睡眠" {
            let record = Record(eventName: "入睡")
            curState = "睡眠"
            DB.addRecord(record)
        }
        stateChange()
        refreshIntervalTime();
    }
    
    @IBAction func wakeUp(_ sender: UIButton) {
        if curState != "清醒" {
            wakeUpTrigger()
        }
        stateChange()
        refreshIntervalTime();
    }
    
    private func wakeUpTrigger() {
        let record = Record(eventName: "醒来")
        curState = "清醒"
        DB.addRecord(record)
        stateChange()
    }
    
    @IBAction func eat(_ sender: UIButton) {
        if curState != "清醒" {
            curState = "清醒"
            wakeUpTrigger()
        }
        let record = Record(eventName: "吃奶")
        DB.addRecord(record)
        refreshIntervalTime();
    }
    
    @IBAction func pop(_ sender: UIButton) {
        if curState != "清醒" {
            curState = "清醒"
            wakeUpTrigger()
        }
        
        let record = Record(eventName: "臭臭")
        DB.addRecord(record)
        refreshIntervalTime();
    }
    
    //set gesture
    private func setGesture() {
        let popGesture = UILongPressGestureRecognizer(target: self, action: #selector(ClockViewController.popLongPressed(gesture: )))
        let eatGesture = UILongPressGestureRecognizer(target: self, action: #selector(eatLongPressed(gesture:)))
        let wakeUpGesture = UILongPressGestureRecognizer(target: self, action: #selector(wakeUpLongPressed(gesture:)))
        let goSleepGesture = UILongPressGestureRecognizer(target: self, action: #selector(goSleepLongPressed(gesture:)))
        pop.addGestureRecognizer(popGesture)
        eat.addGestureRecognizer(eatGesture)
        wakeUp.addGestureRecognizer(wakeUpGesture)
        goSleep.addGestureRecognizer(goSleepGesture)
    }
    
    func popLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressedEvent = Event.pop
            performSegue(withIdentifier: "longPressed", sender: self)
        }
    }
    @objc private func eatLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressedEvent = Event.eat
            performSegue(withIdentifier: "longPressed", sender: self)
        }
    }
    @objc private func wakeUpLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressedEvent = Event.WakeUp
            performSegue(withIdentifier: "longPressed", sender: self)
        }
    }
    @objc private func goSleepLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressedEvent = Event.FallAsleep
            performSegue(withIdentifier: "longPressed", sender: self)
        }
    }
    
    
    //refresh
    func timer() {
        if curState == "睡眠" {
            if colonFlag {
                sleepInterval.text = DB.loadNewestRecordOfEvent(event: Event.FallAsleep)?.timeIntervalTillNow
                colonFlag = false
            } else {
                sleepInterval.text = DB.loadNewestRecordOfEvent(event: Event.FallAsleep)?.timeIntervalTillNowWithoutColon
                colonFlag = true
            }
        } else if curState == "清醒" {
            if colonFlag {
                weakupInterval.text = DB.loadNewestRecordOfEvent(event: Event.WakeUp)?.timeIntervalTillNow
                colonFlag = false
            } else {
                weakupInterval.text = DB.loadNewestRecordOfEvent(event: Event.WakeUp)?.timeIntervalTillNowWithoutColon
                colonFlag = true
            }
        }
    }
    private func stateChange() {
        if curState == "睡眠" {
            sleepState.text = "目前睡眠"
            weakUpState.text = "上次清醒"
            sleepInterval.text = DB.loadNewestRecordOfEvent(event: Event.FallAsleep)?.timeIntervalTillNow
            weakupInterval.text = DB.loadNewestRecordOfEvent(event: Event.FallAsleep)?.descTime

        } else if curState == "清醒" {
            sleepState.text = "上次睡眠"
            weakUpState.text = "目前清醒"
            sleepInterval.text = DB.loadNewestRecordOfEvent(event: Event.WakeUp)?.descTime
            weakupInterval.text = DB.loadNewestRecordOfEvent(event: Event.WakeUp)?.timeIntervalTillNow
        } else {
            sleepState.text = "尚无数据"
            weakUpState.text = "尚无数据"
        }
    }
    
    private func loadCurState() {
        if let lastSleepRecord = DB.loadNewestRecordOfEvent(event: Event.FallAsleep) {
            if let lastWeakUpRecord = DB.loadNewestRecordOfEvent(event: Event.WakeUp) {
                if lastSleepRecord.ID > lastWeakUpRecord.ID {
                    curState = "睡眠"
                } else {
                    curState = "清醒"
                }
            } else {
                curState = "睡眠"
            }
        } else if let _ = DB.loadNewestRecordOfEvent(event: Event.WakeUp) {
            curState = "清醒"
        }
    }
    
    private func refreshIntervalTime() {
        let lastSleepRecord = DB.loadNewestRecordOfEvent(event: Event.FallAsleep)
        let lastWeakUpRecord = DB.loadNewestRecordOfEvent(event: Event.WakeUp)
        let lastEatRecord = DB.loadNewestRecordOfEvent(event: Event.eat)
        let lastPopRecord = DB.loadNewestRecordOfEvent(event: Event.pop)
        
        eatInterval.text = lastEatRecord?.descTime
        popInterval.text = lastPopRecord?.descTime
        
        sleepTime.text = lastSleepRecord?.hourAndMinute
        weakUpTime.text = lastWeakUpRecord?.hourAndMinute
        eatTime.text = lastEatRecord?.hourAndMinute
        popTime.text = lastPopRecord?.hourAndMinute
    }

    @IBAction func timePicked(segue: UIStoryboardSegue) {
        if let datePicker = segue.source as? BottomDatePickerViewController {
            if let date = datePicker.date {
                if longPressedEvent != nil {
                    let record = Record(event: longPressedEvent!, time: date)
                    DB.addRecord(record)
                    loadCurState()
                    refreshIntervalTime()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

