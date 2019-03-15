//
//  TranscribingPopupFragmentCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import ActiveLabel

class TranscribingPopupFragmentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: ActiveLabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        dateLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 15)
        dateLabel.textColor = UIColor(rgb: 0x3D7BFF)
        
        contentLabel.numberOfLines = 0
        contentLabel.lineSpacing = -2
        contentLabel.clipsToBounds = true
    }
    
}
