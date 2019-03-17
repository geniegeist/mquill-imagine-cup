//
//  ADIResponseViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ADIResponseViewController: UIViewController {
    
    var context: String?
    var userResponse: String = "" {
        didSet {
        }
    }
    var adiResponse: String = "" {
        didSet {
        }
    }
    
    @IBOutlet weak var userResponseLabel: UILabel!
    @IBOutlet weak var adiResponseLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userResponseLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        userResponseLabel.textColor = UIColor(white: 1, alpha: 0.5)
        userResponseLabel.numberOfLines = 0
        userResponseLabel.text = userResponse
        
        adiResponseLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        adiResponseLabel.textColor = UIColor(white: 1, alpha: 1)
        adiResponseLabel.numberOfLines = 0
        adiResponseLabel.text = adiResponse
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func microphoneButtonTapped(_ sender: Any) {
        let listeningVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "listening") as! ADIListeningViewController
        listeningVC.context = self.context
        navigationController?.pushViewController(listeningVC, animated: true)
    }
}
