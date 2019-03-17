//
//  LectureTag.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class LectureTag: UILabel {
    
    @IBInspectable var topInset: CGFloat = 2.0
    @IBInspectable var bottomInset: CGFloat = 2.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    private func setupUI() {
        backgroundColor = UIColor(rgb: 0xE8E8E8)
        textColor = UIColor.init(white: 0, alpha: 0.5)
        font = UIFont.brandonGrotesque(weight: .medium, size: 13)
        textAlignment = .center
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }

}
