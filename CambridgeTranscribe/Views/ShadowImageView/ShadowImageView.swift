//
//  ShadowImageView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ShadowImageView: UIImageView {
    
    var gradientLayer: CAGradientLayer!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 800, height: 700)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.9).cgColor]
        gradientLayer.locations = [0.0, 0.7]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
