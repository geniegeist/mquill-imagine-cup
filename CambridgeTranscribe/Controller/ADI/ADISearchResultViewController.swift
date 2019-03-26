//
//  ADISearchResultViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class ADISearchResultViewController: UIViewController {
    
    enum SearchType {
        case lecture
        case transcript
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var context: String?
    var headline: String?
    var results: [LectureDocument]?
    private lazy var textToSpeech: TextToSpeech = {
        return TextToSpeech()
    }()
    
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "ClassSearchResultCell", bundle: nil), forCellReuseIdentifier: "lecture")
        
        titleLabel.text = headline
        titleLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 24)
        titleLabel.textColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var str = "";
        if let result = self.results, result.count > 0 {
            str = "I have found the following lectures"
        } else {
            str = "Sorry couldn't find that"
        }
        textToSpeech.speechFrom(text: str)  { audioData in
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

    @IBAction func micButtonTapped(_ sender: Any) {
        let textVC = UIStoryboard(name: "ADI", bundle: nil).instantiateViewController(withIdentifier: "listening") as! ADIListeningViewController
        textVC.context = context
        navigationController?.pushViewController(textVC, animated: true)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension ADISearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lecture", for: indexPath) as! ClassSearchResultCell
        let document = results![indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy - HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: document.date)
        cell.titleLabel.text = document.name
        cell.transcriptIconView.color = document.color
        cell.transcriptIconView.title = document.shortName
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idx = indexPath.row
        let lecture = results![idx]
        let vc = UIStoryboard(name: "Transcript", bundle: nil).instantiateInitialViewController() as! TranscriptViewController
        
        let store = TranscriptStore.transcripts.allObjects().filter({ $0.lectureId == lecture.id })
        
        vc.transcript = store.first!
        
        present(vc, animated: true, completion: nil)
    }
}
