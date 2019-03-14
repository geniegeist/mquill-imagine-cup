//
//  TranscribingViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import LNPopupController

class TranscribingViewController: UINavigationController {
    
    struct Fragment {
        let id: String
        let date: Date
        var content: String
        var properties: [String : Any]?
        
        init(id: String, date: Date = Date(), content: String, properties: [String: Any]? = nil) {
            self.id = id
            self.date = date
            self.content = content
            self.properties = properties
        }
        
        func withContent(_ content: String) -> Fragment {
            return Fragment(id: self.id, date:self.date, content: content, properties: self.properties)
        }
    }
    
    struct Constants {
        static let maxPopupUtteranceLength = 34
        static let placeholderPopup = "I am listening..."
    }
    
    @IBOutlet weak var pullOverScrollView: UIScrollView!
    @IBOutlet weak var pullOverContentView: UIView!
    private var popupBarController: TranscribingCustomBarViewController!
    
    private lazy var speechToText: CTSpeechToText = {
        let stt = CTSpeechToText()
        stt.delegate = self
        return stt
    }()
    
    private var fragments: [Fragment] = []
    private var currentFragment: Fragment? {
        didSet {
            popupBarController.setContent(currentFragment?.content)
        }
    }
    
    class func createFromStoryboard() -> TranscribingViewController {
        return UIStoryboard.init(name: "Record", bundle: nil).instantiateViewController(withIdentifier: "transcribingViewController") as! TranscribingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        view.backgroundColor = UIColor(rgb: 0xFBFBFF)
        
        let demoVC = TranscribingPopupController()
        
        popupBarController = TranscribingCustomBarViewController.createFromNib()
        popupBarController.setContent(Constants.placeholderPopup, animated: false)
        popupInteractionStyle = .drag
        popupBar.customBarViewController = popupBarController
        popupBar.clipsToBounds = false
        presentPopupBar(withContentViewController: demoVC, animated: true, completion: nil)
        
        popupBar.highlightView.backgroundColor = UIColor(white: 0, alpha: 0.08)
        let path = UIBezierPath(roundedRect:popupBar.highlightView.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        popupBar.highlightView.layer.mask = maskLayer
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        speechToText.startRecognizing()
    }

}

extension TranscribingViewController: CTSpeechToTextDelegate {
    func speech(_ speechToText: CTSpeechToText,
                isReconigizingUtterance utterance: String,
                utteranceId: String) {
        DispatchQueue.main.async {
            if let currentFragment = self.currentFragment {
                self.currentFragment = currentFragment.withContent(utterance)
            } else {
                self.currentFragment = Fragment(id: utterance, content: utterance)
            }
        }
    }
    
    func speech(_ speechToText: CTSpeechToText,
                didRecognizeUtterance utterance: String,
                utteranceId: String) {
        DispatchQueue.main.async {
            self.currentFragment = nil
        }
    }
    
    func speech(toTextDidCancel speechToText: CTSpeechToText) {
        
    }
}
