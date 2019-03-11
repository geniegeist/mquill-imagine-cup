//
//  TranscriptLabel.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//
//

import UIKit

@objc protocol TranscriptLabelActionDelegate {
    @objc optional func transcriptLabel(_ transcriptLabel: TranscriptLabel, didMarkTextIn range: NSRange)
    @objc optional func transcriptLabel(_ transcriptLabel: TranscriptLabel, removeMarkingIn range: NSRange)
    @objc optional func transcriptLabel(_ transcriptLabel: TranscriptLabel, didTap keyword: String)
}

class TranscriptLabel: UITextView {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private lazy var actionMenu: TranscriptActionMenu! = {
        let menu = TranscriptActionMenu(frame: .zero)
        menu.markButton.addTarget(self, action: #selector(mark), for: .touchUpInside)
        return menu
    }()
    
    private lazy var markingMenu: TranscriptMarkingMenu! = {
        let menu = TranscriptMarkingMenu(frame: .zero)
        menu.removeButton.addTarget(self, action: #selector(removeMarking), for: .touchUpInside)
        return menu
    }()
    
    var actionDelegate: TranscriptLabelActionDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        delegate = self
        isEditable = false
        layer.masksToBounds = false // needed so we can show the action menu
        linkTextAttributes = [NSAttributedString.Key : Any]()
        
        if #available(iOS 11.0, *) {
            textDragInteraction?.isEnabled = false
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userDidTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // capture touches outside the frame (e.g., when the menu action is shown)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == 0 {
            return nil
        }
        
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        
        return nil
    }
    
    override func resignFirstResponder() -> Bool {
        actionMenu.removeFromSuperview()
        return super.resignFirstResponder()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // MARK: Action
    
    @objc func mark() {
        actionDelegate?.transcriptLabel?(self, didMarkTextIn: selectedRange)
        selectedTextRange = nil
    }
    
    @objc func userDidTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if (markingMenu.superview != nil) {
            markingMenu.removeFromSuperview()
        }
        
        if (actionMenu.superview != nil) {
            actionMenu.removeFromSuperview()
            selectedTextRange = nil
        }
    }
    
    @objc func removeMarking() {
        actionDelegate?.transcriptLabel?(self, removeMarkingIn: markingMenu.markingRange!)
        markingMenu.removeFromSuperview()
    }
    
}

extension TranscriptLabel: UITextViewDelegate {
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        if let range = textView.selectedTextRange, !range.isEmpty {
            // let selectedText = textView.text(in: range)!
            let caretPositionRect = textView.caretRect(for: range.start)
            let menuFrame = CGRect(x: (bounds.size.width - TranscriptActionMenu.width)/2, y: caretPositionRect.origin.y - TranscriptActionMenu.height - 10, width: TranscriptActionMenu.width, height: TranscriptActionMenu.height)
            actionMenu.frame = menuFrame
            addSubview(actionMenu)
        } else {
            actionMenu.removeFromSuperview()
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if (URL.absoluteString == "marking") {
            let range = characterRange.toTextRange(textView)!
            let caretPositionRect = textView.caretRect(for: range.start)
            let menuFrame = CGRect(x: (bounds.size.width - TranscriptMarkingMenu.width)/2, y: caretPositionRect.origin.y - TranscriptMarkingMenu.height - 10, width: TranscriptMarkingMenu.width, height: TranscriptMarkingMenu.height)
            markingMenu.frame = menuFrame
            markingMenu.markingRange = characterRange
            addSubview(markingMenu)
        } else if (URL.absoluteString == "keyword") {
            let keyword = textView.text(in: characterRange.toTextRange(textView)!)!
            actionDelegate?.transcriptLabel?(self, didTap: keyword)
        }
        
        return false
    }
    
}


private class TranscriptActionMenu: UIView {
    
    static let height: CGFloat = 44
    static let width: CGFloat = 250
    
    private var stackView: UIStackView!
    
    var markButton: UIButton!
    var copyButton: UIButton!
    var shareButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.12
        layer.masksToBounds = false
        
        markButton = UIButton(type: .system)
        markButton.setTitleColor(UIColor(white: 0, alpha: 0.8), for: .normal)
        markButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        markButton.setTitle("Mark", for: .normal)
        
        copyButton = UIButton(type: .system)
        copyButton.setTitleColor(UIColor(white: 0, alpha: 0.8), for: .normal)
        copyButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        copyButton.setTitle("Copy", for: .normal)
        
        shareButton = UIButton(type: .system)
        shareButton.setTitleColor(UIColor(white: 0, alpha: 0.8), for: .normal)
        shareButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        shareButton.setTitle("Share", for: .normal)
        
        stackView = UIStackView(arrangedSubviews: [markButton, copyButton, shareButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.purple
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
}

private class TranscriptMarkingMenu: UIView {
    
    static let height: CGFloat = 44
    static let width: CGFloat = 250
    
    private var stackView: UIStackView!
    
    var removeButton: UIButton!
    
    public var markingRange: NSRange?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.12
        layer.masksToBounds = false
        
        removeButton = UIButton(type: .system)
        removeButton.setTitleColor(UIColor(white: 0, alpha: 0.8), for: .normal)
        removeButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 17)
        removeButton.setTitle("Remove marking", for: .normal)

        
        stackView = UIStackView(arrangedSubviews: [removeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.purple
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
