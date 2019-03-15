//
//  TranscribingCustomBarViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 13.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import LNPopupController
import TOMSMorphingLabel

class TranscribingCustomBarViewController: LNPopupCustomBarViewController {
    
    enum Constants {
        static let barHeight: CGFloat = 64
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var askAdiButton: Button!
    @IBOutlet weak var contentLabel: TOMSMorphingLabel!
    
    class func createFromNib() -> TranscribingCustomBarViewController {
        return UINib(nibName: "TranscribingCustomBarViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! TranscribingCustomBarViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: -1, height: Constants.barHeight)

        view.backgroundColor = UIColor.clear
        view.clipsToBounds = false
        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = false
        
        view.layer.shadowColor = UIColor(rgb: 0x0036FF).cgColor
        view.layer.shadowRadius = 24
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        
        let path = UIBezierPath(roundedRect:contentView.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        contentView.layer.mask = maskLayer
        
        askAdiButton.layer.cornerRadius = 8
        askAdiButton.minimumHitArea = CGSize(width: 16, height: 16)
        playButton.minimumHitArea = CGSize(width: 16, height: 16)
        
        contentLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        contentLabel.textColor = UIColor(rgb: 0x504F5F)
        contentLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        contentLabel.numberOfLines = 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
    }
    
    func setContent(_ content: String?, animated: Bool = true) {
        if (!animated) {
            contentLabel.setTextWithoutMorphing(content)
        } else {
            contentLabel.setText(content, withCompletionBlock: nil)
        }
    }
}
