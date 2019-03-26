//
//  DailySummaryCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 12.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class DailySummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var transcriptIconView: TranscriptIconView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        layer.masksToBounds = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = icon.bounds
        gradientLayer.colors = [UIColor(rgb: 0xFF7676).cgColor, UIColor(rgb: 0xF54EA2).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        icon.layer.insertSublayer(gradientLayer, at: 0)
        icon.layer.cornerRadius = 8
        icon.layer.masksToBounds = true
        icon.backgroundColor = UIColor.red
        
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 16
        mainView.layer.shadowColor = UIColor(rgb: 0x0036FF).cgColor
        mainView.layer.shadowRadius = 24
        mainView.layer.shadowOpacity = 0.08
        
        titleLabel.textColor = UIColor.black
    }
    
}
