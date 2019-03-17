//
//  AskAdiButton.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class AskAdiButton: UIButton {
    
    var siriWave: PXSiriWave!
    var siriDisplayLink: CADisplayLink!

    var isPlaying: Bool = true

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
        layer.cornerRadius = frame.size.height / 2.0
    }
    
    private func setupUI() {
        layer.cornerRadius = frame.size.height / 2.0
    
        siriWave = PXSiriWave(frame: CGRect(x: -100, y: -90, width: 250, height: 250))
        siriWave.backgroundColor = UIColor.clear
        siriWave.layer.masksToBounds = true
        siriWave.intensity = 0.08
        siriWave.amplitude = 4;
        siriWave.frequency = 1
        siriWave.colors = [UIColor(rgb: 0x2085fc), UIColor(rgb: 0x5efca9), UIColor(rgb: 0xfd4767)]
        siriWave.configure()
        siriWave.clipsToBounds = true
        siriWave.isUserInteractionEnabled = false
        addSubview(siriWave)
        
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            self.updateMeters()
        }

        backgroundColor = UIColor(rgb: 0x35355B)
        
        setTitle("ADI", for: .normal)
        titleLabel?.font = UIFont.brandonGrotesque(weight: .bold, size: 17)
        setTitleColor(UIColor.white, for: .normal)
        
        clipsToBounds = true
    }
    
    @objc private func updateMeters() {
        var decibels: CGFloat = 0.1
        decibels = pow((pow(10.0, 0.05 * decibels) - pow(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - pow(10.0, 0.05 * -60.0))), 1.0 / 2.0);
        if (isPlaying) {
            siriWave.update(withLevel: CGFloat(decibels))
        }
    }

}
