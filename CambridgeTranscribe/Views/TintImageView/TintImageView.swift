//
//  TintImageView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TintImageView: UIImageView {

    override var image: UIImage? {
        didSet {
            if image?.renderingMode != UIImage.RenderingMode.alwaysTemplate {
                image = image?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let image = self.image {
            self.image = image.withRenderingMode(.alwaysTemplate)
        }
    }

}
