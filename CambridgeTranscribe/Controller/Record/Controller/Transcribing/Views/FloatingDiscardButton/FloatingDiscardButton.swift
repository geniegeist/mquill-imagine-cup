//
//  FloatingSaveButton.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class FloatingDiscardButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        setTitle("Discard ", for: .normal)
        titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        setTitleColor(UIColor(rgb: 0xEB5454), for: .normal)
        backgroundColor = UIColor(rgb: 0xE9E9E9)
        titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layer.cornerRadius = 4
        sizeToFit()
    }
    
    func presentInView(_ view: UIView, frame: CGRect) {
        if (superview == view) {
            return
        }
        
        self.frame = frame.offsetBy(dx: 0, dy: -40)
        alpha = 0
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.frame = frame
            self.alpha = 1
        }) { (completed) in }
    }
    
    func dismiss() {
        if (self.superview == nil) {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.frame = self.frame.offsetBy(dx: 0, dy: -40)
            self.alpha = 0
        }) { (completed) in
            self.removeFromSuperview()
            self.alpha = 1
        }
    }
    
}
