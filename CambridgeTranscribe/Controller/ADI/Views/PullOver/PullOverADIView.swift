//
//  PullOverADIView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 11.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TOMSMorphingLabel

class PullOverADIView: UIView {
    
    enum State {
        case idle
        case waitingForSpeech
        case processingSpeech
        case processingRequest
        case finished
    }

    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var smallTitleLabel: TOMSMorphingLabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var siriViewContainer: UIView!
    var siriWave: PXSiriWave!
    var siriDisplayLink: CADisplayLink!
    @IBOutlet weak var topHeaderContainer: UIView!
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    var topSiri: PXSiriWave!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var isPlayingMainWave: Bool = false
    var isPlayingTopWave: Bool = false {
        didSet {
            topSiri.isHidden = !isPlayingTopWave
        }
    }
    
    var state: State = .waitingForSpeech {
        didSet {
            if (state == .waitingForSpeech) {
                supportLabel.isHidden = false
                titleLabel.isHidden = false
                smallTitleLabel.isHidden = true
                siriViewContainer.isHidden = false
                activityIndicator.isHidden = true
            } else if (state == .processingSpeech) {
                supportLabel.isHidden = false
                titleLabel.isHidden = true
                smallTitleLabel.isHidden = false
                siriViewContainer.isHidden = false
                activityIndicator.isHidden = true
            } else if (state == .processingRequest) {
                supportLabel.isHidden = false
                titleLabel.isHidden = true
                smallTitleLabel.isHidden = false
                siriViewContainer.isHidden = true
                activityIndicator.isHidden = false
            } else if (state == .finished) {
                supportLabel.isHidden = true
                titleLabel.isHidden = true
                smallTitleLabel.isHidden = false
                siriViewContainer.isHidden = true
                activityIndicator.isHidden = true
            } else if (state == .idle) {
                supportLabel.isHidden = true
                titleLabel.isHidden = true
                smallTitleLabel.isHidden = false
                siriViewContainer.isHidden = false
                activityIndicator.isHidden = true
                
                smallTitleLabel.text = "How can I help you?"
                supportLabel.text = "You can write or speak to ADI"
            }
            
            isPlayingMainWave = !(state == .idle || state == .finished)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setStateToWaitingForSpeech()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        siriWave.frame = siriViewContainer.bounds
    }
    
    //MARK: Setup
    
    private func setupUI() {
        siriWave = PXSiriWave(frame: siriViewContainer.bounds)
        siriWave.backgroundColor = UIColor.clear
        siriWave.layer.masksToBounds = true
        siriWave.intensity = 0.3
        siriWave.amplitude = 0.01;
        siriWave.frequency = 0.1
        siriWave.colors = [UIColor(rgb: 0x2085fc), UIColor(rgb: 0x5efca9), UIColor(rgb: 0xfd4767)]
        siriWave.configure()
        siriViewContainer.insertSubview(siriWave, at: 0)
        siriViewContainer.layer.masksToBounds = true
        siriViewContainer.backgroundColor = UIColor.init(rgb: 0x2A2A49)
        
        siriDisplayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
        siriDisplayLink.add(to: RunLoop.current, forMode: .common)
        
        topSiri = PXSiriWave(frame: topHeaderContainer.bounds)
        topSiri.backgroundColor = UIColor.init(rgb: 0x2A2A49)
        topSiri.layer.masksToBounds = true
        topSiri.intensity = 0.2
        topSiri.amplitude = 0.1
        topSiri.frequency = 0.1
        topSiri.colors = [UIColor(rgb: 0x2085fc), UIColor(rgb: 0x5efca9), UIColor(rgb: 0xfd4767)]
        topSiri.configure()
        topHeaderContainer.addSubview(topSiri)
        
        backgroundColor = UIColor(rgb: 0x2A2A49)
        layer.cornerRadius = 24
        layer.masksToBounds = true
                
        /*
        recognizeVoiceButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        recognizeVoiceButton.setTitleColor(UIColor.white, for: .normal)
        recognizeVoiceButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        recognizeVoiceButton.layer.cornerRadius = 4
        */
    }
    
    @objc private func updateMeters() {
        var decibels = 0.1
        decibels = pow((pow(10.0, 0.05 * decibels) - pow(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - pow(10.0, 0.05 * -60.0))), 1.0 / 2.0);
        
        if (isPlayingMainWave) {
            siriWave.update(withLevel: CGFloat(decibels))
        }
        
        if (isPlayingTopWave) {
            topSiri.update(withLevel: CGFloat(decibels))
        }
    }
    
    //MARK - Public
    
    public func setStateToWaitingForSpeech() {
        state = .waitingForSpeech
        supportLabel.text = "I am listening"
        smallTitleLabel.text = "How can I help you?"
    }
    
    public func setStateToProcessingSpeech(userSpeech: String) {
        state = .processingSpeech
        supportLabel.text = "I am listening"
        smallTitleLabel.text = userSpeech
    }
    
    public func setStateToProcessingRequest(request: String, delayText: String? = nil, delay: Double = 5.0, animated: Bool = true) {
        self.smallTitleLabel.alpha = 0
        self.smallTitleLabel.text = request
        self.smallTitleLabel.isHidden = false
        self.supportLabel.text = "Asking ADI"
        self.titleLabel.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.smallTitleLabel.setText(delayText) {}
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.siriViewContainer.alpha = 0
            self.smallTitleLabel.alpha = 1
        }) { (finished) in
            self.state = .processingRequest
            self.activityIndicator.startAnimating()
            self.siriViewContainer.alpha = 1
        }
    }
    
    public func setStateToFinished(message: String) {
        state = .finished
        smallTitleLabel.text = message
    }
}
