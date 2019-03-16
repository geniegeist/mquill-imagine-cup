//
//  FloatingSaveButton.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class FloatingSaveButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        setTitle("Save transcript", for: .normal)
        titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 20)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor(rgb: 0x3D7BFF)
        titleEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(rgb: 0x0026FF).cgColor
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        sizeToFit()
    }
    
    func presentInView(_ view: UIView, frame: CGRect) {
        if (superview == view) {
            return
        }
        
        self.frame = frame.offsetBy(dx: 0, dy: 40)
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
            self.frame = self.frame.offsetBy(dx: 0, dy: 40)
            self.alpha = 0
        }) { (completed) in
            self.removeFromSuperview()
            self.alpha = 1
        }
    }

}
