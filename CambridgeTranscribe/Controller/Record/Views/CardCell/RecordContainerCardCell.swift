//
//  RecordContainerCardCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class RecordContainerCardCell: CardCell {
    
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }

}
