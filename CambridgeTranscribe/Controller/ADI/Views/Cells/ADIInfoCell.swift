//
//  ADIInfoCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ADIInfoCell: UITableViewCell {
    
    static let cellReuseIdentifier = "ADIInfoCell"

    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       
        backgroundColor = UIColor.clear
        
        contentLabel.textColor = UIColor(white: 1, alpha: 0.66)
        contentLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
    }

    
}
