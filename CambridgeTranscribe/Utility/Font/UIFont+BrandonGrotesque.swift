//
//  Font+Marat.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum BrandonGrotesque {
        enum FontWeight {
            case regular
            case medium
            case bold
            case boldItalic
        }
    }
    
    class func brandonGrotesque(weight: BrandonGrotesque.FontWeight, size: CGFloat) -> UIFont {
        var fontName: String = ""
        switch weight {
        case .regular:
            fontName = "BrandonGrotesque-Regular"
        case .medium:
            fontName = "BrandonGrotesque-Medium"
        case .bold:
            fontName = "BrandonGrotesque-Bold"
        case .boldItalic:
            fontName = "BrandonGrotesque-BoldItalic"
        }
        
        return UIFont.init(name: fontName, size: size)!
    }
}
