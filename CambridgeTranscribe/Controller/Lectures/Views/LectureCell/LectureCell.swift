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
        bgView.frame = bounds
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        bgView = UIView(frame: bounds)
        bgView.backgroundColor = UIColor(rgb: 0x2A2A49)
        insertSubview(bgView, at: 0)
        
        backgroundColor = UIColor(rgb: 0x2A2A49)
        
        let imageGradient = CAGradientLayer()
        imageGradient.frame = leftImageView.bounds
        imageGradient.colors = [UIColor(rgb: 0x5A4BFF).cgColor, UIColor(rgb: 0x5F4CFF).cgColor]
        leftImageView.layer.cornerRadius = 8
        leftImageView.layer.masksToBounds = true
        leftImageView.layer.insertSublayer(imageGradient, at: 0)
        
        dateLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 13)
        dateLabel.textColor = UIColor(white: 1, alpha: 0.35)
        
        headlineLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 17)
        headlineLabel.textColor = UIColor.white
        
        leftImageTitleLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 20)
        leftImageTitleLabel.textColor = UIColor.white
    }
}
