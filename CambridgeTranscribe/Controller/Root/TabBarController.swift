//
//  TabBarController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 28.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {
    @IBOutlet private weak var tabBarViewContainer: UIView!
    var tabBarView: TabBarView = TabBarView.createFromNib()
    
    var color: UIColor = UIColor.white {
        didSet {
            tabBarView.color = color
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarViewContainer.addSubview(tabBarView)
        
        let layoutMarginsGuide = tabBarViewContainer.layoutMarginsGuide
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        tabBarView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        tabBarView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        tabBarView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
