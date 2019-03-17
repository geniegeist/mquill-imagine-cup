//
//  ADIFailViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ADIFailViewController: UIViewController {
    
    public var context: String?
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true

        contentLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        contentLabel.textColor = UIColor(white: 1, alpha: 1)
        contentLabel.text = "I am sorry but I could not understand you. Just try again! You could also type your question by tapping the keyboard icon at the bottom."
        
        retryButton.setTitle("Ask ADI", for: .normal)
        retryButton.setTitleColor(UIColor.white, for: .normal)
        retryButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 20)
        retryButton.layer.cornerRadius = 8
        retryButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }

    @IBAction func keyboardButtonTapped(_ sender: Any) {
        let textVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "text") as! ADITextViewController
        textVC.context = context
        navigationController?.pushViewController(textVC, animated: true)
    }
    
    @IBAction func dimissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
