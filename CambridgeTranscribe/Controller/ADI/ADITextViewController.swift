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
    @IBOutlet weak var bottomBar: UIView!
    
    var disableMicrophone: Bool = false
    
    private lazy var deepPavlov: DeepPavlov = {
        return DeepPavlov()
    }()
    
    
    private lazy var luis: LUIS = {
        return LUIS()
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
        bottomBar.isHidden = disableMicrophone
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
            self.isLoading = true
            // Question answering over text
            deepPavlov.question(question, over: context) { (response) in
                if let str = response, str.count > 0 {
                    print(str)
                    self.isLoading = false
                    let textVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "response") as! ADIResponseViewController
                    textVC.context = context
                    textVC.userResponse = question
                    textVC.adiResponse = str
                    self.navigationController?.pushViewController(textVC, animated: true)
                    
                    self.luis.intentFrom(str, handler: { (response) in
                        let r = response.entities?.filter({ $0.dateValue != nil }).first
                        if let dateStr = r?.dateValue {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateRes = dateFormatter.date(from: dateStr)
                            
                            dateFormatter.dateStyle = .long
                            
                            if (dateRes != nil) {
                                textVC.adiResponse = str + ". That is the \(dateFormatter.string(from: dateRes!))."
                            }

                        }
                    })
                } else {
                    // no answer found
                }
            }
        }
    }
}
