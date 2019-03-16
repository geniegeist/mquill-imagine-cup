//
//  ChooseIconForLectureViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//
// This is very ugly I know xD

import UIKit
import Hero

protocol ChooseIconForLectureViewControllerDelegate {
    func chooseIconDidSelectColor(color: LectureDocument.Color)
}

class ChooseIconForLectureViewController: UIViewController {
    
    struct Constants {
        static let unselectedAlpha: CGFloat = 0.66
    }
    var delegate: ChooseIconForLectureViewControllerDelegate?

    @IBOutlet weak var magenta: TranscriptIconView!
    @IBOutlet weak var turquoise: TranscriptIconView!
    @IBOutlet weak var orange: TranscriptIconView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        magenta.hero.id = "magenta"
        
        magenta.color = .magenta
        turquoise.color = .turquoise
        orange.color = .orange
        
        orange.alpha = Constants.unselectedAlpha
        magenta.alpha = Constants.unselectedAlpha
        turquoise.alpha = Constants.unselectedAlpha
    }

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func magentaTapped(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.chooseIconDidSelectColor(color: .magenta)
        
        magenta.alpha = 1
        turquoise.alpha = Constants.unselectedAlpha
        orange.alpha = Constants.unselectedAlpha
    }
    
    @IBAction func turquoiseTapped(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.chooseIconDidSelectColor(color: .turquoise)
        
        turquoise.alpha = 1
        magenta.alpha = Constants.unselectedAlpha
        orange.alpha = Constants.unselectedAlpha
    }
    
    @IBAction func orangeTapped(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.chooseIconDidSelectColor(color: .orange)
        
        orange.alpha = 1
        magenta.alpha = Constants.unselectedAlpha
        turquoise.alpha = Constants.unselectedAlpha
    }
    
    
}
