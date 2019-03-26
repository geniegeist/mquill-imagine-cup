//
//  ADIResponseViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class ADIResponseViewController: UIViewController {
    
    var context: String?
    var userResponse: String = "" {
        didSet {
        }
    }
    var adiResponse: String = "" {
        didSet {
            adiResponseLabel?.text = adiResponse
        }
    }
    
    @IBOutlet weak var userResponseLabel: UILabel!
    @IBOutlet weak var adiResponseLabel: UILabel?
    
    private lazy var textToSpeech: TextToSpeech = {
        return TextToSpeech()
    }()

    
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        userResponseLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        userResponseLabel.textColor = UIColor(white: 1, alpha: 0.5)
        userResponseLabel.numberOfLines = 0
        userResponseLabel.text = userResponse
        
        adiResponseLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        adiResponseLabel?.textColor = UIColor(white: 1, alpha: 1)
        adiResponseLabel?.numberOfLines = 0
        adiResponseLabel?.text = adiResponse
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textToSpeech.speechFrom(text: adiResponse)  { audioData in
            DispatchQueue.main.async {
                guard let data = audioData else { return }
                let audioSession = AVAudioSession.init()
                do {
                    try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker]) // options is important otherwise the sound is very quiet
                    try audioSession.setActive(true)
                    
                    self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.wav.rawValue)
                    self.audioPlayer!.prepareToPlay()
                    self.audioPlayer!.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
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
