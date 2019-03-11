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
        backgroundColor = UIColor.init(white: 1, alpha: 0.12)
        textColor = UIColor.init(white: 1, alpha: 0.8)
        font = UIFont.brandonGrotesque(weight: .medium, size: 13)
        textAlignment = .center
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }

}
