//
//  RecordsTableViewController.swift
//  BabyClock
//
//  Created by pz1943 on 2016/12/19.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func eventFilter(_ sender: UIButton) {
        let alert = UIAlertController(title: "筛选", message: "请选择要显示的类别", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Event.FallAsleep.rawValue, style: .default, handler: { (action) in
            self.filterEvent = Event.FallAsleep
            self.reloadRecords()
        }))

        alert.addAction(UIAlertAction(title: Event.WakeUp.rawValue, style: .default, handler: { (action) in
            self.filterEvent = Event.WakeUp
            self.reloadRecords()
        }))
        alert.addAction(UIAlertAction(title: Event.eat.rawValue, style: .default, handler: { (action) in
            self.filterEvent = Event.eat
            self.reloadRecords()
        }))
        alert.addAction(UIAlertAction(title: Event.pop.rawValue, style: .default, handler: { (action) in
            self.filterEvent = Event.pop
            self.reloadRecords()
        }))
        alert.addAction(UIAlertAction(title: Event.all.rawValue, style: .default, handler: { (action) in
            self.filterEvent = Event.all
            self.reloadRecords()
        }))
        self.present(alert, animated: false) {        }
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadRecords()
    }
    var DB: RecordDB = RecordDB()
    var filterEvent = Event.all
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func reloadRecords() {
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DB.countOfEvent(event: filterEvent)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = DB.loadRecordFromIndexOfEvent(indexPath.row, event: filterEvent)
        let cell = tableView.dequeueReusableCell(withIdentifier: "record cell", for: indexPath) as! RecordTableViewCell
        if record != nil {
            cell.EventName.text = record?.eventName
            cell.Describetion.text = record?.description
            cell.EventTime.text = record?.hourAndMinute
            cell.EventDate.text = record?.monthAndDay
            cell.DescTime.text = record?.descTime
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let record = DB.loadRecordFromIndex(indexPath.row) {
                DB.delRecord(record.ID)
            }
            reloadRecords()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
