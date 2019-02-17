//
//  RecordTabBarItem.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Pulsator

class RecordTabBarItem: UIButton {

    @IBOutlet private weak var outerCircle: UIView!
    @IBOutlet private weak var innerCircle: UIView!
    
    private var pulsator: Pulsator!

    var isRecording: Bool = false {
        didSet {
            if (isRecording) {
                pulsator.start()
                primaryColor = UIColor.red
            } else {
                pulsator.stop()
                primaryColor = UIColor.white
            }
        }
    }
    var primaryColor: UIColor = UIColor.white {
        didSet {
            outerCircle.layer.borderColor = primaryColor.cgColor
            innerCircle.backgroundColor = primaryColor
        }
    }
    
    @objc class func createFromStoryboard() -> RecordTabBarItem {
        return UINib.init(nibName: "RecordTabBarItem", bundle: nil).instantiate(withOwner: self, options: nil).first as! RecordTabBarItem
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerCircle.layer.borderWidth = 4
        outerCircle.layer.borderColor = primaryColor.cgColor
        outerCircle.backgroundColor = UIColor.clear
        // view swallows touch events which prevents the button to recognize any events like touch up inside
        outerCircle.isUserInteractionEnabled = false
        
        innerCircle.backgroundColor = primaryColor
        // view swallows touch events which prevents the button to recognize any events like touch up inside
        innerCircle.isUserInteractionEnabled = false
        
        pulsator = Pulsator()
        // center pulse
        pulsator.position = innerCircle.center
        pulsator.numPulse = 3
        pulsator.radius = 50
        pulsator.animationDuration = 3
        pulsator.backgroundColor = UIColor.white.cgColor
        layer.insertSublayer(pulsator, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // center pulse
        pulsator.position = innerCircle.center
    }
    
    //MARK: Public action
}
