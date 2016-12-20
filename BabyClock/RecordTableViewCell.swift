//
//  RecordTableViewCell.swift
//  BabyClock
//
//  Created by pz1943 on 2016/12/13.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventDate: UILabel!
    @IBOutlet weak var EventTime: UILabel!
    @IBOutlet weak var Describetion: UILabel!

    @IBOutlet weak var DescTime: UILabel!
}
