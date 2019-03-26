//
//  ADIViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 11.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Hero

class ADIViewController: UINavigationController {
    
    var context: String?
    var disableMicrophone: Bool = false
    var customModalAnimationType: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        hero.isEnabled = true
        if (!customModalAnimationType) {
            hero.modalAnimationType = .autoReverse(presenting: .zoom)
        }
        hero.navigationAnimationType = .autoReverse(presenting: .zoom)
        view.backgroundColor = UIColor.black

        if (!disableMicrophone) {
            let listeningVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "listening") as! ADIListeningViewController
            listeningVC.context = context
            setViewControllers([listeningVC], animated: false)
        } else {
            let textVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "text") as! ADITextViewController
            textVC.context = context
            textVC.disableMicrophone = true
            setViewControllers([textVC], animated: false)
        }
        
    }
}
