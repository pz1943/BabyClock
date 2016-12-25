//
//  BottomDatePickerViewController.swift
//  BabyClock
//
//  Created by pz1943 on 2016/12/23.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import UIKit

class BottomDatePickerViewController: UIViewController {
    //FIXME: should show from bottom
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale
        self.view.layer.opacity = 1
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.layer.opacity = 0.99
        pickerContainer.layer.cornerRadius = 5
        pickerContainer.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var pickerContainer: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    var date: Date?
    @IBAction func submit(_ sender: UIButton) {
        date = datePicker.date
        performSegue(withIdentifier: "timePicked", sender: self)
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
