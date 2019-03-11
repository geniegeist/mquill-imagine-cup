//
//  RecordContainerViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Motion

class RecordViewController: UIViewController {
    
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var headlineLabel: UILabel!
    
    private lazy var transcribingViewController: TranscribingViewController = {
        return TranscribingViewController.createFromStoryboard()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgb: 0x393B66)
        
        headlineLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 32)
        headlineLabel.textColor = UIColor.white
        
        animateRecordButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: Animation

private extension RecordViewController {
    
    private enum RecordButtonState {
        case normal
        case expanded
    }
    
    private func animateRecordButton() {
        let duration: TimeInterval = 2
        let expandFactor: CGFloat = 1.05

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .repeat, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                self.recordButton.transform = CGAffineTransform(scaleX: expandFactor, y: expandFactor)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6, animations: {
                self.recordButton.transform = .identity
            })
        })
    }
    
    /*
    private func animateRecordButton(_ state: RecordButtonState) {
        let duration: TimeInterval = 1.1
        let timingFunction = CAMediaTimingFunction.easeInOut
        let expandFactor: CGFloat = 1.05
        
        UIView.animate(withDuration: duration, animations: {
            self.recordButton.transform = CGAffineTransform(scaleX: expandFactor, y: expandFactor)
        }) { (completed) in
            <#code#>
        }
        
        if (state == .normal) {
            recordButton.animate([.scale(1.01), .duration(duration), .timingFunction(.linear)]) {
                self.animateRecordButton(.expanded)
            }
        } else if (state == .expanded) {
            recordButton.animate([.scale(expandFactor), .duration(duration), .timingFunction(.linear)]) {
                self.recordButton.animate([.scale(), .duration(duration), .timingFunction(.linear)]) {
                    self.animateRecordButton(.expanded)
                }
            }
        }
    }*/
}
