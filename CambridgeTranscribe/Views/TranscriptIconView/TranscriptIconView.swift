//
//  TranscriptIconView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TranscriptIconView: UIView {
    
    var color: LectureDocument.Color = .magenta {
        didSet {
            guard let gradientLayer = self.gradientLayer else { return }
            gradientLayer.colors = TranscriptIconView.gradientColors(color)
        }
    }
    
    private var titleLabel: UILabel!
    private var gradientLayer: CAGradientLayer!
    var imageView: UIImageView!

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        imageView.frame = bounds
        titleLabel.frame = imageView.bounds
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = TranscriptIconView.gradientColors(color)
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        
        imageView = UIImageView(frame: bounds)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.frame = imageView.bounds
        titleLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 11)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byClipping
        imageView.addSubview(titleLabel)
    }

    class func gradientColors(_ color: LectureDocument.Color) -> [CGColor] {
        if (color == .magenta) {
            return [UIColor(rgb: 0xFF7676).cgColor, UIColor(rgb: 0xF54EA2).cgColor]
        } else if (color == .turquoise) {
            return [UIColor(rgb: 0x17EAD9).cgColor, UIColor(rgb: 0x6078EA).cgColor]
        } else if (color == .orange) {
            return [UIColor(rgb: 0xFCE38A).cgColor, UIColor(rgb: 0xF38181).cgColor]
        }
        
        return []
    }
}
