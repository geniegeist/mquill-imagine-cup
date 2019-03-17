//
//  TranscriptViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

protocol TranscriptViewControllerDelegate {
    func transcriptViewController(_ vc: TranscriptViewController, didChange transcript: TranscriptDocument)
}

class TranscriptViewController: UIViewController {
    
    @IBOutlet weak var headerImageView: ShadowImageView!
    @IBOutlet weak var headerBottomBar: UIView!
    @IBOutlet weak var headerBackground: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private var scrollViewTopBackground: UIView!
    @IBOutlet weak var transcriptIconView: TranscriptIconView?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var audioPlaybackContainer: UIView!
    private var audioPlaybackProgress: TranscriptAudioPlaybackProgress!
    
    public var transcript: TranscriptDocument?
    @IBOutlet weak var fragmentStackView: UIStackView!
    
    var delegate: TranscriptViewControllerDelegate?
    
    lazy private var textToSpeech: TextToSpeech = {
      return TextToSpeech()
    }()
    var audioPlayer: AVAudioPlayer?
    var audioDisplayLink: CADisplayLink?
    
    private var askAdiButton: AskAdiButton!
    
    public var color: LectureDocument.Color = .magenta {
        didSet {
            transcriptIconView?.color = color
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let askAdiSize: CGFloat = 64
        askAdiButton = AskAdiButton(frame: CGRect(x: view.bounds.size.width - askAdiSize - 16, y: view.bounds.size.height - askAdiSize - 24, width: askAdiSize, height: askAdiSize))
        view.addSubview(askAdiButton)
        askAdiButton.addTarget(self, action: #selector(askAdiButtonTapped), for: .touchUpInside)
        askAdiButton.hero.id = "batman"
        askAdiButton.cornerRadius = 16
                
        scrollViewTopBackground = UIView()
        scrollViewTopBackground.frame = CGRect(x: 0, y: -800, width: view.bounds.size.width, height: 800)
        scrollViewTopBackground.backgroundColor = UIColor(rgb: 0x2A2A49)
        scrollView.addSubview(scrollViewTopBackground)

        scrollView.backgroundColor = UIColor.white
        headerBottomBar.backgroundColor = UIColor.white
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy - HH:mm"
        if let date = transcript?.date {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        dateLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        dateLabel.textColor = UIColor(white: 1, alpha: 1)
        
        headlineLabel.text = transcript?.title
        headlineLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 32)
        headlineLabel.textColor = UIColor.white

        transcriptIconView?.color = color
        transcriptIconView?.title = LectureStore.lectures.object(withId: transcript!.lectureId)!.shortName
        
        audioPlaybackContainer.backgroundColor = UIColor.clear
        audioPlaybackProgress = UINib(nibName: "TranscriptAudioPlaybackProgress", bundle: nil).instantiate(withOwner: self, options: nil).first as? TranscriptAudioPlaybackProgress
        audioPlaybackProgress.frame = audioPlaybackContainer.bounds
        audioPlaybackContainer.addSubview(audioPlaybackProgress)
        audioPlaybackProgress.playButton.addTarget(self, action: #selector(playAudioButtonTapped), for: .touchUpInside)
        
        if let transcript = self.transcript {
            for fragment in transcript.fragments {
                let fragmentView = TranscriptFragmentView(frame: fragmentStackView.bounds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                
                fragmentView.id = fragment.id
                fragmentView.date = dateFormatter.string(from: fragment.date)
                fragmentView.content = TranscriptFragmentView.AttributeMaker.attributedString(fragment)
                fragmentView.isFavourite = fragment.isFavourite
                fragmentView.delegate = self
                
                fragmentStackView.addArrangedSubview(fragmentView)
            }
        }
        
        fragmentStackView.sizeToFit()
        fragmentStackView.backgroundColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewTopBackground.frame = CGRect(x: 0, y: -800, width: view.bounds.size.width, height: 800)
        audioPlaybackProgress.frame = audioPlaybackContainer.bounds
    }
    
    //MARK: Actions
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func playAudioButtonTapped() {
        if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
            return;
        }
        
        guard let content = transcript?.fragments.first?.content else { return }
        self.audioPlaybackProgress.state = TranscriptAudioPlaybackProgress.State.processing

        textToSpeech.speechFrom(text: content) { audioData in
            DispatchQueue.main.async {
                guard let data = audioData else { return }
                let audioSession = AVAudioSession.init()
                do {
                    self.audioPlaybackProgress.state = TranscriptAudioPlaybackProgress.State.preparingAudio

                    try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker]) // options is important otherwise the sound is very quiet
                    try audioSession.setActive(true)
                    
                    self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.wav.rawValue)
                    self.audioPlayer!.delegate = self
                    self.audioPlayer!.prepareToPlay()
                    self.audioPlayer!.play()

                    self.audioPlaybackProgress.state = TranscriptAudioPlaybackProgress.State.playing
                    
                    self.audioDisplayLink = CADisplayLink(target: self, selector: #selector(self.updateAudioProgress))
                    self.audioDisplayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func askAdiButtonTapped() {
        let vc = UIStoryboard(name: "ADI", bundle: nil).instantiateInitialViewController() as! ADIViewController
        let context = transcript?.fragments.map({ $0.content }).joined(separator: " ")
        vc.context = context
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: Audio
    
    @objc private func updateAudioProgress() {
        guard let audioPlayer = self.audioPlayer else {
            audioDisplayLink?.invalidate()
            return
        }
        
        if (audioPlayer.isPlaying) {
            let progress: Float = Float(audioPlayer.currentTime / audioPlayer.duration)
            audioPlaybackProgress.progressView.setProgress(progress, animated: false)
        } else {
            audioDisplayLink?.invalidate()
            audioPlaybackProgress.state = TranscriptAudioPlaybackProgress.State.finished
        }
    }
}

extension TranscriptViewController: TranscriptFragmentViewDelegate {
    
    func transcriptFragmentLikeButtonTapped(_ fragmentView: TranscriptFragmentView) {
        let fragmentId = fragmentView.id!
        let index = transcript!.fragments.firstIndex(where: { $0.id == fragmentId })!
        var fragment = transcript!.fragments[index]
        fragment.isFavourite = !fragment.isFavourite
        transcript!.fragments[index] = fragment
        
        fragmentView.isFavourite = fragment.isFavourite
        
        delegate?.transcriptViewController(self, didChange: transcript!)
    }
    
    func transcriptFragmentPlayButtonTapped(_ fragment: TranscriptFragmentView) { }
    
    func transcriptFragment(_ fragmentView: TranscriptFragmentView, markTextIn range: NSRange) {
        let fragmentId = fragmentView.id!
        let index = transcript!.fragments.firstIndex(where: { $0.id == fragmentId })!
        var fragment = transcript!.fragments[index]
        fragment.tags.append(TranscriptTag(name: .marking, range: range))

        fragmentView.content = TranscriptFragmentView.AttributeMaker.attributedString(fragment)
        
        transcript!.fragments[index] = fragment
        delegate?.transcriptViewController(self, didChange: transcript!)
    }
    
    func transcriptFragment(_ fragmentView: TranscriptFragmentView, removeMarkingIn range: NSRange) {
        let fragmentId = fragmentView.id!
        let index = transcript!.fragments.firstIndex(where: { $0.id == fragmentId })!
        var fragment = transcript!.fragments[index]
        
        let filteredTags = fragment.tags.filter { !($0.name == TranscriptTagName.marking && ($0.range.location <= range.location && $0.range.location + $0.range.length >= range.location + range.length)) }
        fragment.tags = filteredTags
        
        fragmentView.content = TranscriptFragmentView.AttributeMaker.attributedString(fragment)

        transcript!.fragments[index] = fragment
        delegate?.transcriptViewController(self, didChange: transcript!)
    }
    
    func transcriptFragment(_ fragmentView: TranscriptFragmentView, didTapKeyword keyword: String) {
        let entityVC = UIStoryboard(name: "Entity", bundle: nil).instantiateInitialViewController() as! EntityViewController
        entityVC.title = keyword
        entityVC.content = "Frequency is the number of occurrences of a repeating event per unit of time. It is also referred to as temporal frequency, which emphasizes the contrast to spatial frequency and angular frequency. The period is the duration of time of one cycle in a repeating event, so the period is the reciprocal of the frequency. For example: if a newborn baby's heart beats at a frequency of 120 times a minute, its period—the time interval between beats—is half a second."
        navigationController?.pushViewController(entityVC, animated: true)
    }

}


extension TranscriptViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlaybackProgress.progressView.setProgress(1, animated: true)
        audioDisplayLink?.invalidate()
        audioPlaybackProgress.state = TranscriptAudioPlaybackProgress.State.finished
    }
    
}
