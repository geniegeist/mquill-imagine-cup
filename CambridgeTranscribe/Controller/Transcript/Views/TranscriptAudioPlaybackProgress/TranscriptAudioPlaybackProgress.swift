//
//  TranscriptAudioPlaybackProgress.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TranscriptAudioPlaybackProgress: UIView {

    @IBOutlet weak var progressView: UIProgressView!
    
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
    }

}
