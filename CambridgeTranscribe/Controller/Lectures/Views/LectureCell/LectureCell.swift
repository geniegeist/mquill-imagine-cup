//
//  LectureCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class LectureCell: UICollectionViewCell {
    
    @IBOutlet weak var transcriptIconViewTitleLabel: UILabel!
    @IBOutlet weak var transcriptIconView: TranscriptIconView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        dateLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 13)
        dateLabel.textColor = UIColor(rgb: 0xB7B7B7)
        
        headlineLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 20)
        headlineLabel.textColor = UIColor(rgb: 0x3F3E51)
        
        transcriptIconViewTitleLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 15)
        transcriptIconViewTitleLabel.textColor = UIColor.white
    }
}
