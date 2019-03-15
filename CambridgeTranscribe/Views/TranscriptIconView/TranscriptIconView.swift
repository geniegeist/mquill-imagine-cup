//
//  TranscriptIconView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TranscriptIconView: UIView {
    
    enum Color {
        case magenta
        case turquoise
    }
    
    var color: Color = .magenta {
        didSet {
            guard let gradientLayer = self.gradientLayer else { return }
            gradientLayer.colors = TranscriptIconView.gradientColors(color)
        }
    }
    
    private var gradientLayer: CAGradientLayer!
    
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
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = TranscriptIconView.gradientColors(color)
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    class func gradientColors(_ color: Color) -> [CGColor] {
        if (color == .magenta) {
            return [UIColor(rgb: 0xFF7676).cgColor, UIColor(rgb: 0xF54EA2).cgColor]
        } else if (color == .turquoise) {
            return [UIColor(rgb: 0x17EAD9).cgColor, UIColor(rgb: 0x6078EA).cgColor]
        }
        
        return []
    }
}
