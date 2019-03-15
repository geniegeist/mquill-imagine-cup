//
//  PlayButton.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class PlayButton: Button {
    
    var isPlaying: Bool = false {
        didSet {
            if (isPlaying) {
                self.setImage(UIImage(named: "II"), for: .normal)
                self.imageEdgeInsets = .zero
            } else {
                self.setImage(UIImage(named: "play-triangle"), for: .normal)
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
