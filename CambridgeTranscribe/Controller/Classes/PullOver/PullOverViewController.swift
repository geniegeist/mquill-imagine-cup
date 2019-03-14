//
//  PullOverViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 11.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class PullOverViewController: UIViewController {
    
    var dismissThreshold: CGFloat = 350 {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: dismissThreshold, left: 0, bottom: 0, right: 0)
        }
    }
    
    var childHeight: CGFloat = 400 {
        didSet {
            if let child = self.childViewController {
                child.view.frame = contentFrame()
            }
            
            if let contentView = self.contentView {
                contentView.frame = contentFrame()
            }
        }
    }
    
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
    
    var scrollView: UIScrollView!
    var childViewController: UIViewController? {
        didSet {
            guard let child = self.childViewController else { return }
            child.view.frame = contentFrame()
                
            addChild(child)
            scrollView.addSubview(child.view)
            child.willMove(toParent: self)
            
            scrollView.contentSize = CGSize(width: view.bounds.size.width, height: view.frame.size.height)
        }
    }
    
    var contentView: UIView? {
        didSet {
            guard let contentView = self.contentView else { return }
            contentView.frame = contentFrame()
            scrollView.addSubview(contentView)
            
            scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.frame.size.height)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: dismissThreshold, left: 0, bottom: 0, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: dismissThreshold)
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: Helper
    
    private func contentFrame() -> CGRect {
        return CGRect(x: contentInset.left,
                      y: view.frame.size.height - childHeight - contentInset.bottom,
                      width: view.frame.size.width - contentInset.left - contentInset.right,
                      height: childHeight)
    }
}

extension PullOverViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOff = scrollView.contentOffset.y
        if (yOff <= 0) {
            let rel = 1 - abs(yOff) / dismissThreshold
            scrollView.backgroundColor = UIColor(white: 0, alpha: min(rel,0.95))
        }
    }
}
