//
//  ADIListeningViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ADIListeningViewController: UIViewController {
    
    public var context: String?
    
    @IBOutlet weak var adiViewContainer: UIView!
    @IBOutlet weak var userUtteranceLabel: UILabel!
    var adiView: PullOverADIView!
    
    var hasRestarted: Bool = false
    
    //MARK: Model
    
    var isRecognizing: Bool = true {
        didSet {
            if let recognized = self.recognizedUtterance, recognized.count > 0 {
                if (!isRecognizing) {
                    adiView.setStateToProcessingRequest(request: "I am searching for the answer", delayText: "I almost got it", delay: 3)
                }
            } else {
                // failed to recognize anything
                if navigationController?.topViewController == self {
                    let listeningVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "fail") as! ADIFailViewController
                    listeningVC.context = context
                    navigationController?.pushViewController(listeningVC, animated: true)
                }
            }
        }
    }
    var currentUtterance: String? {
        didSet {
            userUtteranceLabel.text = currentUtterance
        }
    }
    var recognizedUtterance: String? {
        didSet {
            userUtteranceLabel.text = recognizedUtterance
        }
    }
    
    private lazy var speechToText: CTSpeechToText = {
        let sts = CTSpeechToText()
        sts.delegate = self
        return sts
    }()
    
    private lazy var deepPavlov: DeepPavlov = {
        return DeepPavlov()
    }()
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hero.isEnabled = true
        
        adiView = UINib(nibName: "PullOverADIView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PullOverADIView
        adiView.frame = adiViewContainer.bounds
        adiView.isPlayingTopWave = false
        adiView.isPlayingMainWave = false
        adiView.keyboardButton.addTarget(self, action: #selector(keyboardButtonTapped), for: .touchUpInside)
        adiView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        adiView.hero.id = "batman"
        adiView.siriWave.isHidden = true
        
        adiViewContainer.addSubview(adiView)
        adiViewContainer.backgroundColor = UIColor.clear
        
        userUtteranceLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        userUtteranceLabel.textColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        adiView.siriWave.isHidden = false
        adiView.isPlayingMainWave = true
        
        DispatchQueue.global(qos: .default).async {
            self.recognizeFromMicrophone()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        speechToText.stopRecognizing()
    }
    
    //MARK: Actions
    
    @objc func keyboardButtonTapped() {
        let textVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "text") as! ADITextViewController
        textVC.context = context
        navigationController?.pushViewController(textVC, animated: true)
    }
    
    @objc func retryButtonTapped() {
        currentUtterance = nil
        recognizedUtterance = nil
        hasRestarted = true
        speechToText.stopRecognizing()
        speechToText.startRecognizing()
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: Speech
    
    private func recognizeFromMicrophone() {
        speechToText.startRecognizing()
    }
    
    //MARK: Pavlov
    
    private func askPavlov(_ question: String) {
        if let context = self.context {
            // Question answering over text
            deepPavlov.question(question, over: context) { (response) in
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


//MARK: Text to Speech Delegate

extension ADIListeningViewController: CTSpeechToTextDelegate {
    func speech(_ speechToText: CTSpeechToText,
                didRecognizeUtterance utterance: String,
                utteranceId: String) {
        if (hasRestarted) {
            hasRestarted = false
            return
        }
        
        speechToText.stopRecognizing()
        DispatchQueue.main.async {
            self.recognizedUtterance = utterance
            self.isRecognizing = false
        }
        
        DispatchQueue.global(qos: .default).async {
            self.askPavlov(utterance)
        }
    }
    
    func speech(_ speechToText: CTSpeechToText, isReconigizingUtterance utterance: String, utteranceId: String) {
        DispatchQueue.main.async {
            self.currentUtterance = utterance
        }
    }
    
    func speech(toTextDidCancel speechToText: CTSpeechToText) {
        
    }
}
