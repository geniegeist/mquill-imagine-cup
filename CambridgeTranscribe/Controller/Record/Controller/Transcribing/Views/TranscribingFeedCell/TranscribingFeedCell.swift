//
//  TranscribingFeedCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import ActiveLabel

class TranscribingFeedCell: UITableViewCell {
    
    var feedIdentifier: String?

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: ActiveLabel!
    @IBOutlet weak var transcriptIconView: TranscriptIconView!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear

        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor.white
        mainView.layer.shadowRadius = 24
        mainView.layer.shadowColor = UIColor(rgb: 0x0036FF).cgColor
        mainView.layer.shadowOpacity = 0.08
        mainView.layer.shadowOffset = .zero
        mainView.clipsToBounds = false
        
        titleLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 20)
        titleLabel.textColor = UIColor(white: 0, alpha: 0.66)
        
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.brandonGrotesque(weight: .regular, size: 17)
        contentLabel.textColor = UIColor(white: 0, alpha: 0.66)
        
        copyrightLabel.font = UIFont.brandonGrotesque(weight: .regular, size: 12)
        copyrightLabel.textColor = UIColor(white: 0, alpha: 0.33)
        copyrightLabel.text = "Wikipedia"
        
        transcriptIconView.imageView.image = UIImage(named: "Taylor-Swift-revenge-nerds")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        transcriptIconView.imageView.image = nil
        transcriptIconView.isHidden = false
    }

}
