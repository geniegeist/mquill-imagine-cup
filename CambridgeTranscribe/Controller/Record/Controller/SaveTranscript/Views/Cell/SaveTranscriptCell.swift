//
//  SaveTranscriptCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class SaveTranscriptCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transcriptIconView: TranscriptIconView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 22)
        titleLabel.textColor = UIColor.white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        transcriptIconView.imageView.image = nil
        transcriptIconView.title = nil
    }

}
