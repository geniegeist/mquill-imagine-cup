//
//  FloatingActivityFeedIndicator.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView

class FloatingActivityFeedIndicator: UIView {
    
    var siriWave: SwiftSiriWaveformView!
    
    var decibels: CGFloat = 0.1 {
        didSet {
            if (isPlaying) {
                let level = pow((pow(10.0, 0.05 * decibels) - pow(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - pow(10.0, 0.05 * -60.0))), 1.0 / 2.0);
                siriWave.amplitude = level * 3
            } else {
                siriWave.amplitude = 0
            }
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            siriWave.phaseShift = isPlaying ? 0.08 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
        siriWave.frame = bounds
    }
    
    private func setupUI() {
        backgroundColor = UIColor.red
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
        
        siriWave = SwiftSiriWaveformView()
        siriWave.frame = bounds
        siriWave.backgroundColor = UIColor(rgb: 0x3D7BFF)
        siriWave.numberOfWaves = 4
        siriWave.frequency = 1.5
        siriWave.idleAmplitude = 0
        siriWave.phaseShift = 0.08
        siriWave.waveColor = UIColor(rgb: 0xffffff)
        addSubview(siriWave)
    }
}
