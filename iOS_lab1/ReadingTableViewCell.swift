//
//  ReadingTableViewCell.swift
//  iOS_lab1
//
//  Created by Admin on 11/12/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ReadingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("In awakeFromNib")
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
