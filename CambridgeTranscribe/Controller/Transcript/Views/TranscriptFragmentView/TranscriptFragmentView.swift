//
//  TranscriptTextParagraph.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

@objc protocol TranscriptFragmentViewDelegate {
    @objc optional func transcriptFragmentLikeButtonTapped(_ fragmentView: TranscriptFragmentView)
    @objc optional func transcriptFragmentPlayButtonTapped(_ fragmentView: TranscriptFragmentView)
    @objc optional func transcriptFragment(_ fragmentView: TranscriptFragmentView, markTextIn range: NSRange)
    @objc optional func transcriptFragment(_ fragmentView: TranscriptFragmentView, removeMarkingIn range: NSRange)
    @objc optional func transcriptFragment(_ fragmentView: TranscriptFragmentView, didTapKeyword keyword: String)
}

class TranscriptFragmentView: UIView {
    
    var id: String?
    var dateLabel: UILabel!
    var date: String? = "10:15 AM" {
        didSet {
            dateLabel.text = date
            dateLabel.sizeToFit()
        }
    }
    
    var content: NSAttributedString? {
        didSet {
            transcriptLabel.attributedText = content
            transcriptLabel.frame = rectForTranscriptLabel()
        }
    }
    
    var isFavourite: Bool = false {
        didSet {
            favouriteButton.tintColor = isFavourite ? UIColor(rgb: 0xFF4866) : UIColor(rgb: 0xC0C0C0)
        }
    }
    
    // Delegate
    
    var delegate: TranscriptFragmentViewDelegate?
    
    // UI
    
    private var favouriteButton: UIButton!
    private var playButton: UIButton!
    private var transcriptLabel: TranscriptLabel!
    
    // Internal properties
    
    override var intrinsicContentSize: CGSize {
        let rect = rectForTranscriptLabel()
        return CGSize(width: bounds.size.width, height: rect.size.height + dateLabel.frame.size.height + 24)
    }
    
    // Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // we need the frame from the very beginning to caluclate the correct size
    // something that we could do better in the future ;)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = rectForDateLabel()
        dateLabel.sizeToFit()
        favouriteButton.frame = rectForFavouriteButton()
        playButton.frame = rectForPlayButton()
        transcriptLabel.frame = rectForTranscriptLabel()
    }
    
    private func setupUI() {
        dateLabel = UILabel(frame: rectForDateLabel())
        dateLabel.text = date
        dateLabel.font = UIFont.brandonGrotesque(weight: .medium, size: 15)
        dateLabel.textColor = UIColor(white: 0, alpha: 0.25)
        dateLabel.sizeToFit()
        addSubview(dateLabel)
        
        favouriteButton = UIButton(type: .system)
        favouriteButton.frame = rectForFavouriteButton()
        favouriteButton.setImage(UIImage(named: "like"), for: .normal)
        favouriteButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        addSubview(favouriteButton)
        
        playButton = UIButton(type: .system)
        playButton.frame = rectForPlayButton()
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.tintColor = UIColor(rgb: 0xC0C0C0)
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        addSubview(playButton)
        
        transcriptLabel = TranscriptLabel()
        transcriptLabel.frame = rectForTranscriptLabel()
        transcriptLabel.actionDelegate = self
        addSubview(transcriptLabel)
    }
    
    // MARK: Action
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        delegate?.transcriptFragmentLikeButtonTapped?(self)
    }
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        delegate?.transcriptFragmentPlayButtonTapped?(self)
    }

    // MARK: Helper
    
    private func rectForDateLabel() -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    private func rectForFavouriteButton() -> CGRect {
        let x = dateLabel.frame.maxX + 12
        let y = dateLabel.frame.origin.y
        return CGRect(x: x, y:y, width: 25, height: 25)
    }
    
    private func rectForPlayButton() -> CGRect {
        let x = favouriteButton.frame.maxX + 12
        let y = favouriteButton.frame.origin.y
        return CGRect(x: x, y:y, width: 25, height: 25)
    }
    
    private func rectForTranscriptLabel() -> CGRect {
        let size = transcriptLabel.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        return CGRect(x: 0, y: dateLabel.frame.maxY + 16, width: max(size.width, frame.size.width), height: size.height)
    }
}

extension TranscriptFragmentView: TranscriptLabelActionDelegate {
    func transcriptLabel(_ transcriptLabel: TranscriptLabel, didMarkTextIn range: NSRange) {
        delegate?.transcriptFragment?(self, markTextIn: range)
    }
    
    func transcriptLabel(_ transcriptLabel: TranscriptLabel, removeMarkingIn range: NSRange) {
        delegate?.transcriptFragment?(self, removeMarkingIn: range)
    }
    
    func transcriptLabel(_ transcriptLabel: TranscriptLabel, didTap keyword: String) {
        delegate?.transcriptFragment?(self, didTapKeyword: keyword)
    }
}

extension TranscriptFragmentView {
    
    struct AttributeMaker {
        static func attributedString(_ fragment: TranscriptFragment) -> NSAttributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 12
            
            let str = NSMutableAttributedString(string: fragment.content,
                                                attributes: [NSAttributedString.Key.font : UIFont.maratPro(weight: .regular, size: 20),
                                                             NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.66),
                                                             NSAttributedString.Key.paragraphStyle : paragraphStyle])
            
            for tag in fragment.tags {
                let range = tag.range

                if (tag.name == .marking) {
                    str.addAttributes([NSAttributedString.Key.link: URL(string: "marking")!,
                                       NSAttributedString.Key.backgroundColor: UIColor(rgb: 0xFFE785)], range: range)
                }
                
                if (tag.name == .keyword) {
                    str.addAttributes([NSAttributedString.Key.link: URL(string: "keyword")!,
                                       NSAttributedString.Key.foregroundColor : UIColor(rgb: 0xE47627),
                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                       NSAttributedString.Key.underlineColor : UIColor(rgb: 0xFFDFC9)], range: range)
                }
            }
            
            return str
        }
    }
    
}
