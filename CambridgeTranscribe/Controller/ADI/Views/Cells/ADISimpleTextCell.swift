//
//  ADISimpleTextCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ADISimpleTextCell: UITableViewCell {
    
    static let cellReuseIdentifier = "ADISimpleTextCell"

    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentLabel.textColor = UIColor.white
        contentLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
    }
    
}
