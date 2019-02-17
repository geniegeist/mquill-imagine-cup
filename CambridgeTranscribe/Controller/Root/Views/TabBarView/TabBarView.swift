//
//  TabBarView.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TabBarView: UIView {
    
    // Left Tab Bar Item
    @IBOutlet private weak var leftTabBarImageView: TintImageView!
    @IBOutlet private weak var leftTabBarTitleLabel: UILabel!
    
    // Center Tab Bar Item
    @IBOutlet private weak var centerItemHintView: UIView!
    @IBOutlet private weak var centerItemContainer: UIView!
    var recordTabBarItem: RecordTabBarItem = RecordTabBarItem.createFromStoryboard()
    
    // Right Tab Bar Item
    @IBOutlet private weak var rightTabBarImageView: TintImageView!
    @IBOutlet weak var rightTabBarTitleLabel: UILabel!
    
    // General appearance
    var color: UIColor = UIColor.white {
        didSet {
            recordTabBarItem.primaryColor = color
            leftTabBarImageView.tintColor = color
            rightTabBarImageView.tintColor = color
            
            rightTabBarTitleLabel.textColor = color
            leftTabBarTitleLabel.textColor = color
        }
    }
    var isRecording: Bool {
        get {
            return recordTabBarItem.isRecording
        }
        set {
            recordTabBarItem.isRecording = newValue
        }
    }
    var didTapRecordTabBarItemBlock: ((TabBarView) -> Void)?
    var didTapLeftTabBarItemBlock: ((TabBarView) -> Void)?
    var didTapRightTabBarItemBlock: ((TabBarView) -> Void)?

    // Methods
    
    class func createFromNib() -> TabBarView {
        return UINib.init(nibName: "TabBarView", bundle: nil).instantiate(withOwner: self, options: nil).first as! TabBarView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.animate(withDuration: 0.3) {
            self.centerItemHintView.alpha = self.bounds.size.height <= 130 ? 0 : 1
        }
    }
    
    //MARK: Action
    
    @objc private func userDidTapRecordTabBarItem() {
        print("user did tap record tab bar item")
        if let didTapBlock = didTapRecordTabBarItemBlock {
            didTapBlock(self)
        }
    }
    
    @IBAction func userDidTapLeftTabBarItem(_ sender: Any) {
        print("user did tap left tab bar item")
        if let didTapBlock = didTapLeftTabBarItemBlock {
            didTapBlock(self)
        }
    }
    
    @IBAction func userDidTapRightTabBarItem(_ sender: Any) {
        print("user did tap right tab bar item")
        if let didTapBlock = didTapRightTabBarItemBlock {
            didTapBlock(self)
        }
    }
    
    //MARK: Setup User Interface
    
    private func setupUI() {
        // Center Tab Bar Item
        centerItemContainer.backgroundColor = UIColor.clear
        centerItemContainer.addSubview(recordTabBarItem)
        
        let layoutMarginsGuide = centerItemContainer.layoutMarginsGuide
        recordTabBarItem.translatesAutoresizingMaskIntoConstraints = false
        recordTabBarItem.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        recordTabBarItem.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        recordTabBarItem.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        recordTabBarItem.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        recordTabBarItem.addTarget(self, action: #selector(userDidTapRecordTabBarItem), for: .touchUpInside)
    }

}
