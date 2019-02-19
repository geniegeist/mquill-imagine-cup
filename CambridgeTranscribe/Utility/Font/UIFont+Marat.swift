//
//  Font+Marat.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum MaratPro {
        enum FontWeight {
            case regular
            case regularItalic
            case medium
            case mediumItalic
            case bold
            case boldItalic
        }
    }
    
    class func maratPro(weight: MaratPro.FontWeight, size: CGFloat) -> UIFont? {
        var fontName: String = ""
        switch weight {
        case .regular:
            fontName = "MaratPro-Regular"
        case .regularItalic:
            fontName = "MaratPro-RegularItalic"
        case .medium:
            fontName = "MaratPro-Medium"
        case .mediumItalic:
            fontName = "MaratPro-MediumItalic"
        case .bold:
            fontName = "MaratPro-Bold"
        case .boldItalic:
            fontName = "MaratPro-BoldItalic"
        }
        
        return UIFont.init(name: fontName, size: size)
    }
}
