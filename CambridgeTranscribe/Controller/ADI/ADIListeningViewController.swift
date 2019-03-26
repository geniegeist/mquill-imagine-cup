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
    
    @IBOutlet weak var adiViewContainer: UIScrollView!
    @IBOutlet weak var userUtteranceLabel: UILabel!
    var adiView: PullOverADIView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet var hints: [UILabel]!
    
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
    
    private lazy var luis: LUIS = {
        return LUIS()
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
        adiView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        adiView.hero.id = "batman"
        adiView.siriWave.isHidden = true
        
        adiViewContainer.addSubview(adiView)
        adiViewContainer.backgroundColor = UIColor.clear
        adiViewContainer.alwaysBounceVertical = true
        
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
        
        DispatchQueue.global(qos: .default).async {
            self.speechToText.stopRecognizing()
        }
        
        self.speechToText.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    @objc func doneButtonTapped() {
        speechToText.stopRecognizing()
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
                    
                    self.luis.intentFrom(str, handler: { (response) in
                        let r = response.entities?.filter({ $0.dateValue != nil }).first
                        if let dateStr = r?.dateValue {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateRes = dateFormatter.date(from: dateStr)
                            if (dateRes != nil) {
                                textVC.adiResponse = str + "That is \(dateRes!)."
                            }
                        }
                    })
                } else {
                    // no answer found
                }
            }
        }
    }
    
    private func searchForLecture(name: String?, dateStr: String?) {
        let vc = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "search") as! ADISearchResultViewController
        vc.context = context
        var name = name
        print(name)
        print(dateStr)
        
        if (name != nil) {
            name = name!.replacingOccurrences(of: ".", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let results = LectureStore.findLecturesWith(name: name, dateStr: dateStr)
        vc.results = results
        
        if (name != nil && dateStr == nil) {
            vc.headline = "Here are the lectures under the \(name!)"
        } else if (name == nil && dateStr != nil) {
            vc.headline = "Here are the lectures from a specific date"
        } else if (name != nil && dateStr != nil) {
            vc.headline = "Here are the lectures that match the timeframe and title"
        } else if (name == nil && dateStr == nil) {
            vc.headline = "Unfortunately, I could not find anything"
        }
        
        if (results?.count == 0) {
            vc.headline = "Unfortunately, I could not find anything"
        }
        
        navigationController?.pushViewController(vc, animated: true)
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
        
        luis.intentFrom(utterance) { response in
            if let topNotchIntent = response.topScoringIntent?.intent, let score = response.topScoringIntent?.score {
                
                // find lectures
                if (topNotchIntent == LUISIntent.Identifier.findClass) {
                    let entities = response.entities
                    let lectureEntity = entities?.filter({ $0.type == "ClassName" }).first
                    let dateEntity = entities?.filter({ $0.type == "builtin.datetimeV2.date" }).first
                                        
                    let dateValue = dateEntity?.dateValue
                    if (score > 0.65) {
                        self.searchForLecture(name: lectureEntity?.entity, dateStr: dateValue)
                    } else {
                        self.askPavlov(utterance)
                    }
                } else {
                    self.askPavlov(utterance)
                }
                
            } else {
                self.askPavlov(utterance)
            }
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
