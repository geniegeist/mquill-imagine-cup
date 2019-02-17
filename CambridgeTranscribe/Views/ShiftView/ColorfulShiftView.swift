//
//  ShiftView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Shift

class ColorfulShiftView: ShiftView {
    
    private let COLORS = [
        UIColor.init(red: 156/255.0, green: 39/255.0, blue: 176/255.0, alpha: 1.0),
        UIColor.init(red: 255/255.0, green: 64/255.0, blue: 129/255.0, alpha: 1.0),
        UIColor.init(red: 123/255.0, green: 31/255.0, blue: 162/255.0, alpha: 1.0),
        UIColor.init(red: 32/255.0, green: 76/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor.init(red: 32/255.0, green: 158/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor.init(red: 90/255.0, green: 120/255.0, blue: 127/255.0, alpha: 1.0),
        UIColor.init(red: 58/255.0, green: 255/255.0, blue: 217/255.0, alpha: 1.0)
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setColors(COLORS)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setColors(COLORS)
    }
    
}
