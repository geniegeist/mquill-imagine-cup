//
//  PlayButton.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class PlayButton: Button {
    
    enum Size {
        case normal
        case large
    }
    
    var size: Size = .normal {
        didSet {
            if (!self.isPlaying) {
                if (size == .normal) {
                    self.setImage(UIImage(named: "play-triangle"), for: .normal)
                } else {
                    self.setImage(UIImage(named: "play-triangle-large"), for: .normal)
                }
            }
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            if (isPlaying) {
                if (size == .normal) {
                    self.setImage(UIImage(named: "II"), for: .normal)
                } else {
                    self.setImage(UIImage(named: "II-large"), for: .normal)
                }
                self.imageEdgeInsets = .zero
            } else {
                if (size == .normal) {
                    self.setImage(UIImage(named: "play-triangle"), for: .normal)
                } else {
                    self.setImage(UIImage(named: "play-triangle-large"), for: .normal)
                }
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
    }
    
    private func setupUI() {
        backgroundColor = UIColor(rgb: 0x3D7BFF)
        layer.cornerRadius = bounds.size.width / 2
        
        isPlaying = false
    }

}
