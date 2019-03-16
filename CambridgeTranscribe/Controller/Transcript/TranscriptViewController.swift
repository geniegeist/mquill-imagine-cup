//
//  TranscriptViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

protocol TranscriptViewControllerDelegate {
    func transcriptViewController(_ vc: TranscriptViewController, didChange transcript: TranscriptDocument)
}

class TranscriptViewController: UIViewController {
    
    @IBOutlet weak var headerBackground: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private var scrollViewTopBackground: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var audioPlaybackContainer: UIView!
    private var audioPlaybackProgress: TranscriptAudioPlaybackProgress!
    @IBOutlet weak var askADIButton: Button!
    
    public var transcript: TranscriptDocument?
    @IBOutlet weak var fragmentStackView: UIStackView!
    
    var delegate: TranscriptViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        scrollViewTopBackground = UIView()
        scrollViewTopBackground.frame = CGRect(x: 0, y: -800, width: view.bounds.size.width, height: 800)
        scrollViewTopBackground.backgroundColor = UIColor(rgb: 0x2A2A49)
        scrollView.addSubview(scrollViewTopBackground)
        scrollView.backgroundColor = UIColor(rgb: 0x2A2A49)
        
        askADIButton.centerTextAndImage(spacing: 8)
        
        let imageGradient = CAGradientLayer()
        imageGradient.frame = leftImageView.bounds
        imageGradient.colors = [UIColor(rgb: 0x5A4BFF).cgColor, UIColor(rgb: 0x5F4CFF).cgColor]
        leftImageView.layer.cornerRadius = 8
        leftImageView.layer.masksToBounds = true
        leftImageView.layer.insertSublayer(imageGradient, at: 0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy - HH:mm"
        if let date = transcript?.date {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        dateLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        dateLabel.textColor = UIColor(white: 1, alpha: 0.5)
        
        headlineLabel.text = transcript?.title
        headlineLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 32)
        headlineLabel.textColor = UIColor.white

        audioPlaybackProgress = UINib(nibName: "TranscriptAudioPlaybackProgress", bundle: nil).instantiate(withOwner: self, options: nil).first as? TranscriptAudioPlaybackProgress
        audioPlaybackProgress.frame = audioPlaybackContainer.bounds
        audioPlaybackContainer.addSubview(audioPlaybackProgress)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.backgroundColor = UIColor(rgb: 0xffffff)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewTopBackground.frame = CGRect(x: 0, y: -800, width: view.bounds.size.width, height: 800)
        audioPlaybackProgress.frame = audioPlaybackContainer.bounds
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func transcriptFragmentPlayButtonTapped(_ fragment: TranscriptFragmentView) {
        
    }
    
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
