//
//  ADITextViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SkyFloatingLabelTextField

class ADITextViewController: UIViewController {

    public var context: String?
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var activityIndicatorViewSize: NSLayoutConstraint!
    
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var askButton: UIButton!
    
    private lazy var deepPavlov: DeepPavlov = {
        return DeepPavlov()
    }()
    
    var request: String = "" {
        didSet {
            if (request.count > 0) {
                askButton.isEnabled = true
                askButton.alpha = 1
            } else {
                askButton.isEnabled = false
                askButton.alpha = 0.33
            }
        }
    }
    
    private var isLoading: Bool = false {
        didSet {
            if (oldValue == isLoading) {
                return
            }
            
            if (isLoading) {
                activityIndicatorViewSize.constant = 28
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorViewSize.constant = 0
                activityIndicatorView.stopAnimating()
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorViewSize.constant = 0
        askButton.isEnabled = false
        askButton.alpha = 0.33
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    

    @IBAction func askButtonTapped(_ sender: Any) {
        askPavlov(request)
    }
    
    @IBAction func microphoneButtonTapped(_ sender: Any) {
        let listeningVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "listening") as! ADIListeningViewController
        listeningVC.context = self.context
        navigationController?.pushViewController(listeningVC, animated: true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        request = textField.text ?? ""
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapAnywhere(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    //MARK: DeepPavlov
    
    private func askPavlov(_ question: String) {
        if let context = self.context {
            isLoading = true
            // Question answering over text
            deepPavlov.question(question, over: context) { (response) in
                self.isLoading = false
                
                if let str = response, str.count > 0 {
                    print(str)
                    let textVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "response") as! ADIResponseViewController
                    textVC.context = context
                    textVC.userResponse = question
                    textVC.adiResponse = str
                    self.navigationController?.pushViewController(textVC, animated: true)
                } else {
                    // no answer found
                }
            }
        }
    }
}
