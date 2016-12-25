//
//  FilterSelectingViewController.swift
//  BabyClock
//
//  Created by pz1943 on 2016/12/22.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import UIKit

class FilterSelectingViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    
    var event: Event?
//
    @IBAction func all(_ sender: UIButton) {
        event = Event.all
        performSegue(withIdentifier: "dismiss", sender: self)
    }

    @IBAction func sleep(_ sender: UIButton) {
        event = Event.FallAsleep
        performSegue(withIdentifier: "dismiss", sender: self)
    }
    
    @IBAction func weakUp(_ sender: UIButton) {
        event = Event.WakeUp
        performSegue(withIdentifier: "dismiss", sender: self)
    }
    
    @IBAction func eat(_ sender: UIButton) {
        event = Event.eat
        performSegue(withIdentifier: "dismiss", sender: self)
    }
    
    @IBAction func pop(_ sender: UIButton) {
        event = Event.pop
        performSegue(withIdentifier: "dismiss", sender: self)
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
