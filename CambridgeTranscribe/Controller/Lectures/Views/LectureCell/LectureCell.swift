//
//  LectureCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class LectureCell: UICollectionViewCell {
    
    @IBOutlet weak var leftImageTitleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    
    var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        
        let imageGradient = CAGradientLayer()
        imageGradient.frame = leftImageView.bounds
        imageGradient.colors = [UIColor(rgb: 0x56BDFF).cgColor, UIColor(rgb: 0x4255E1).cgColor]
        leftImageView.layer.cornerRadius = 8
        leftImageView.layer.masksToBounds = true
        leftImageView.layer.insertSublayer(imageGradient, at: 0)
        
        dateLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 13)
        dateLabel.textColor = UIColor(rgb: 0xB7B7B7)
        
        headlineLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 17)
        headlineLabel.textColor = UIColor(rgb: 0x3F3E51)
        
        leftImageTitleLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 20)
        leftImageTitleLabel.textColor = UIColor.white
    }
}
