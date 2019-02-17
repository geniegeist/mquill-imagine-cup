//
//  CircleView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint = CGPoint.zero, radius: CGFloat) {
        super.init(frame: CGRect(x: position.x, y: position.y, width: radius, height: radius));
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2.0;
    }
    
}
