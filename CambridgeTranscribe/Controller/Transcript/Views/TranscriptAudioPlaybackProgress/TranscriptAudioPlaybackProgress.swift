//
//  TranscriptAudioPlaybackProgress.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TranscriptAudioPlaybackProgress: UIView {
    
    enum State {
        case initial
        case playing
        case paused
        case processing // send to microsoft
        case preparingAudio // prepare audio on device
        case finished
    }

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingViewLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    public var state: State = .initial {
        didSet {
            playButton.isPlaying = (state == .playing)
            if (state == .processing || state == .preparingAudio) {
                loadingViewLabel.text = "Synthesizing speech from transcript"
                UIView.animate(withDuration: 0.3) {
                    self.loadingView.alpha = 1
                }
                activityIndicator.startAnimating()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.loadingView.alpha = 0
                }, completion: { completed in
                    self.activityIndicator.stopAnimating()
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
        progressView.layer.cornerRadius = progressView.bounds.size.height / 2
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        progressView.layer.masksToBounds = true
        progressView.progress = 0
        layer.borderColor = UIColor(rgb: 0xE3E3E3).cgColor
        layer.borderWidth = 1
        
        loadingView.layer.cornerRadius = loadingView.bounds.size.height / 2.0
        loadingViewLabel.textColor = UIColor.white
        loadingViewLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowRadius = 8
        loadingView.layer.shadowOpacity = 0.2
        loadingView.alpha = 0
    }

}
