//
//  ADIViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 11.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Hero

class ADIViewController: UIViewController {
    
    struct Response {
        enum Kind {
            case text
            case info
        }
        
        let kind: Kind
        let value: Any
    }
    
    enum State {
        case idle
        case waitingForUserSpeech
        case waitingForTextInput
        case processingTextInput
        case processingUserSpeech
        case presenting
    }
    
    enum Action {
        case voice
        case text
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var adiViewContainer: UIView!
    @IBOutlet weak var adiViewContainerBottomConstraint: NSLayoutConstraint!
    var adiView: PullOverADIView!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var activityIndicatorSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var startVoiceButton: AskAdiButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    private var responses: [Response] = []
    
    private lazy var deepPavlov: DeepPavlov = {
       return DeepPavlov()
    }()
    var context: String?
    
    private lazy var speechToText: CTSpeechToText = {
        return CTSpeechToText()
    }()
    
    private var state: State = .waitingForUserSpeech {
        didSet {
            if (state == .waitingForTextInput) {
                textField.isHidden = false
                textField.becomeFirstResponder()
                askButton.isEnabled = true
                askButton.alpha = 1
                textField.isEnabled = true
                adiViewContainerBottomConstraint.constant = -200
                
                actionType = .text

                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    self.adiView.isHidden = true
                    self.adiView.isPlayingMainWave = false
                }
            } else if (state == .processingTextInput) {
                activityIndicatorSizeConstraint.constant = 28
                textField.resignFirstResponder()
                askButton.isEnabled = false
                askButton.alpha = 0.5
                textField.isEnabled = false
                adiView.isHidden = true
                adiView.isPlayingMainWave = false
            } else {
                activityIndicatorSizeConstraint.constant = 0
                adiView.isHidden = false
                adiView.isPlayingMainWave = true
                adiViewContainerBottomConstraint.constant = 16
                
                textField.resignFirstResponder()
                textField.text = nil
                UIView.animate(withDuration: 0.3, animations: {
                    self.textField.alpha = 0
                    self.askButton.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    self.textField.isHidden = true
                    self.textField.alpha = 1
                    self.askButton.isHidden = true
                    self.askButton.alpha = 1
                }
            }
            
            if (state == .processingUserSpeech) {
                startVoiceButton.setImage(UIImage(named: "microphone"), for: .normal)
            }
            
            if (state == .presenting) {
                tableView.isHidden = false
                startVoiceButton.isHidden = false
                adiView.isHidden = true
            } else {
                tableView.isHidden = true
                startVoiceButton.isHidden = true
            }
        }
    }
    
    private var actionType: Action? = nil {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        hero.modalAnimationType = .autoReverse(presenting: .zoom)
        view.backgroundColor = UIColor.black

        adiView = UINib(nibName: "PullOverADIView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PullOverADIView
        adiView.frame = adiViewContainer.bounds
        adiView.isPlayingTopWave = false
        adiView.isPlayingMainWave = true
        adiViewContainer.addSubview(adiView)
        adiView.keyboardButton.addTarget(self, action: #selector(keyboardButtonTapped), for: .touchUpInside)
        adiView.recognizeVoiceButton.addTarget(self, action: #selector(recognizeVoiceButtonTapped), for: .touchUpOutside)
        adiView.hero.id = "batman"
        
        textField.backgroundColor = UIColor.clear
        textField.isHidden = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueDidChange(_:)), for: .editingChanged)
        
        askButton.layer.cornerRadius = 4
        askButton.isHidden = true
        
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor(rgb: 0xffffff)
        activityIndicatorSizeConstraint.constant = 0
        
        startVoiceButton.backgroundColor = UIColor.black
        startVoiceButton.isHidden = true
        startVoiceButton.setTitle("", for: .normal)
        startVoiceButton.tintColor = UIColor(white: 1, alpha: 1)
        startVoiceButton.clipsToBounds = false
        startVoiceButton.setImage(UIImage(named: "microphone"), for: .normal)
        startVoiceButton.bringSubviewToFront(startVoiceButton.imageView!)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ADISimpleTextCell", bundle: nil), forCellReuseIdentifier: ADISimpleTextCell.cellReuseIdentifier)
        tableView.register(UINib(nibName: "ADIInfoCell", bundle: nil), forCellReuseIdentifier: ADIInfoCell.cellReuseIdentifier)
        tableView.isHidden = true

        
        // Debug
        /*
        state = .presenting
        responses.append(Response(kind: .info, value: "Wie ist es so?"))
        responses.append(Response(kind: .text, value: "Hallo ja das ist richtig"))
        tableView.reloadData()
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Pavlov
    
    private func askPavlov(_ question: String) {
        if let context = self.context {
            // Question answering over text
            deepPavlov.question(question, over: context) { (response) in
                let str = response ?? "I am sorry, I could not find an answer to your question."
                let answer = Response(kind: .text, value: str)
                let info = Response(kind: .info, value: question)
                
                DispatchQueue.main.async {
                    self.responses.append(info)
                    self.responses.append(answer)
                    self.tableView.reloadData()
                    self.state = .presenting
                }
            }
        }
        
    }
    
    private func recognizeFromMicrophone() {
        
        speechToText.recognizeUtterance { (result) in
            self.askPavlov(result)
        }

    }
    
    //MARK: Action
    
    // AdiView Action
    @objc func keyboardButtonTapped() {
        state = .waitingForTextInput
        actionType = .text
    }
    
    @objc func recognizeVoiceButtonTapped() {
        state = .waitingForUserSpeech
        actionType = .voice
    }
    
    @objc func textFieldValueDidChange(_ sender: UITextField) {
        if (sender == textField) {
            if let value = textField.text {
                askButton.isHidden = value.count == 0
            }
        }
    }
    
    @IBAction func askButtonTapped(_ sender: Any) {
        state = .processingTextInput
        
        if let text = textField.text {
            askPavlov(text)
        }
    }
    
    @IBAction func tapped(_ sender: Any) {
        textField.resignFirstResponder()
        startVoiceButton.isHidden = state != .waitingForTextInput
        
        if (state == .waitingForTextInput) {
            actionType = .voice
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startVoiceButtonTapped(_ sender: Any) {
        if (actionType == .voice) {
            state = .waitingForUserSpeech
        } else {
            state = .waitingForTextInput
            textField.becomeFirstResponder()
        }
    }
}

extension ADIViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = responses[indexPath.row]
        let kind = response.kind
        
        if (kind == .text) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ADISimpleTextCell.cellReuseIdentifier, for: indexPath) as! ADISimpleTextCell
            
            let content = response.value as? String
            cell.content = content ?? "Unfortunately I have not found an answer"
            
            return cell
        } else if (kind == .info) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ADIInfoCell.cellReuseIdentifier, for: indexPath) as! ADIInfoCell
            
            let content = response.value as? String
            cell.content = content ?? "Unfortunately I have not found an answer"
            
            return cell
        }
        
        return UITableViewCell()
    }
}


extension ADIViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField.text?.count ?? 0 > 0) {
            state = .processingTextInput
            askPavlov(textField.text!)
        }
        
        return true
    }
    
}
