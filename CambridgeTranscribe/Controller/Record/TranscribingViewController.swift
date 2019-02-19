//
//  TranscribingViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TranscribingViewController: UIViewController {
    
    class func createFromStoryboard() -> TranscribingViewController {
        return UIStoryboard.init(name: "Record", bundle: nil).instantiateViewController(withIdentifier: "transcribingViewController") as! TranscribingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
