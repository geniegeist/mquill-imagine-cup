//
//  RecordButton.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 08.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    
    private var gradientBG: CAGradientLayer!
    private var quillImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2.0
        gradientBG.frame = bounds
        quillImageView.frame = quillImageViewRect()
    }

    private func setupUI() {
        layer.masksToBounds = true
        
        gradientBG = CAGradientLayer()
        gradientBG.frame = bounds
        gradientBG.colors = [UIColor(rgb: 0x323232, opacity: 0.4).cgColor, UIColor(rgb: 0x1A1C23, opacity: 0.4).cgColor]
        gradientBG.locations = [0,1]
        layer.insertSublayer(gradientBG, at: 0)
        
        
        quillImageView = UIImageView(image: UIImage(named: "quill"))
        quillImageView.frame = quillImageViewRect()
        quillImageView.contentMode = .scaleAspectFit
        quillImageView.layer.shadowColor = UIColor(rgb: 0x003AFF).cgColor
        quillImageView.layer.shadowOffset = .zero
        quillImageView.layer.shadowOpacity = 0.5
        quillImageView.layer.shadowRadius = 32
        addSubview(quillImageView)
    }
    
    private func quillImageViewRect() -> CGRect {
        let size = bounds.size.width * 0.8
        let rect = CGRect(x: (bounds.size.width - size) * 0.5, y: (bounds.size.height - size) * 0.5, width: size, height: size)
        return rect
    }
    
}



/*
 import UIKit
 import Shift
 import Motion
 
 class RecordButton: UIView {
 
 private var circle: ColorfulCircleShiftView!
 private var waveView: SCSiriWaveformView!
 
 public var didTapBlock: (() -> Void)?
 
 override func awakeFromNib() {
 super.awakeFromNib()
 setupUI()
 }
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 setupUI()
 }
 
 required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 }
 
 override func layoutSubviews() {
 super.layoutSubviews()
 }
 
 private func setupUI() {
 backgroundColor = UIColor.clear
 
 let center = CGPoint(x: bounds.size.width/2.0, y: bounds.size.height / 2.0)
 let size = CGSize(width: bounds.size.width, height: bounds.size.width)
 circle = ColorfulCircleShiftView(frame: CGRect(center: center, size: size))
 circle.startTimedAnimation()
 addSubview(circle)
 
 waveView = SCSiriWaveformView.init(frame: circle.bounds)
 circle.addSubview(waveView)
 
 waveView.backgroundColor = UIColor.clear
 waveView.waveColor = UIColor.init(white: 1, alpha: 0.7)
 waveView.primaryWaveLineWidth = 2.0
 waveView.secondaryWaveLineWidth = 1
 waveView.phaseShift = 0.012
 
 let displayLink = CADisplayLink.init(target: self, selector: #selector(updateMeters))
 displayLink.add(to: RunLoop.current, forMode: .common)
 
 animateFrom()
 
 let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tap))
 addGestureRecognizer(tapGesture)
 }
 
 @objc private func tap() {
 if let block = didTapBlock {
 block()
 }
 }
 
 private func animateFrom() {
 circle.animate([MotionAnimation.scale(1.03), MotionAnimation.duration(1.2), .timingFunction(.easeInOut)]) {
 self.animateTo()
 }
 }
 
 private func animateTo() {
 circle.animate([MotionAnimation.scale(), MotionAnimation.duration(1.2), .timingFunction(.easeInOut)]) {
 self.animateFrom()
 }
 }
 
 @objc private func updateMeters() {
 let normalizedValue = _normalizedPowerLevelFromDecibels()
 waveView.update(withLevel: CGFloat(normalizedValue))
 }
 
 private func _normalizedPowerLevelFromDecibels() -> Float {
 let random = Int.random(in: 0..<2500)
 let decibels: Float = -36.0 + Float(random) / 10000
 if (decibels < -60.0 || decibels == 0.0) {
 return 0.0
 }
 
 return powf((powf(10.0, 0.05 * decibels) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0)
 }
 }
 */
