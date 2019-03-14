//
//  RecordContainerViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    struct Constants {
        static let pullOverThreshold: CGFloat = 320
        static let pullOverTopInset: CGFloat = 64
    }
    
    @IBOutlet weak var transcribeContainerView: UIScrollView!
    @IBOutlet weak var transcribeView: UIView!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var pullOverScrollView: UIScrollView!
    @IBOutlet weak var topPullOverScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullOverScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var darkView: UIView!
    
    private var adiView: PullOverADIView!
    private var adiViewOriginFrame: CGRect {
        return CGRect(x: 12, y: Constants.pullOverTopInset, width: view.bounds.size.width - 12 * 2, height: 264)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        transcribeView.layer.cornerRadius = 16
        transcribeView.layer.shadowColor = UIColor(rgb: 0x0036FF).cgColor
        transcribeView.layer.shadowOpacity = 0.1
        transcribeView.layer.shadowRadius = 32
        transcribeView.layer.shadowPath = UIBezierPath(roundedRect: transcribeView.frame, cornerRadius: 16).cgPath
        
        transcribeButton.layer.cornerRadius = 12
        
        pullOverScrollView.contentSize = CGSize(width: view.bounds.size.width, height: Constants.pullOverThreshold+finalPullOverOffset()+Constants.pullOverTopInset)
        pullOverScrollViewHeightConstraint.constant = Constants.pullOverThreshold + Constants.pullOverTopInset
        
        adiView = UINib(nibName: "PullOverADIView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PullOverADIView
        adiView.frame = adiViewOriginFrame
        adiView.isPlayingTopWave = true
        adiView.isPlayingMainWave = false
        pullOverScrollView.addSubview(adiView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adiView.frame = adiViewOriginFrame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func transcribeButtonTapped(_ sender: Any) {
        let transcribingVC = TranscribingViewController.createFromStoryboard()
        present(transcribingVC, animated: true, completion: nil)
    }
    
    //MARK: Helper
    
    private func finalPullOverOffset() -> CGFloat {
        let extra = view.frame.size.height - transcribeContainerView.frame.maxY - 22
        return Constants.pullOverThreshold - extra
    }
}

extension RecordViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == pullOverScrollView) {
            let offset = scrollView.contentOffset.y
            topPullOverScrollViewConstraint.constant = -offset
            adiView.frame = adiViewOriginFrame.offsetBy(dx: 0, dy: offset)
            
            let opacity = offset / finalPullOverOffset()
            darkView.alpha = opacity * 2.2
            
            if (offset  >= Constants.pullOverThreshold * 0.5) {
                adiView.isPlayingTopWave = false
                adiView.isPlayingMainWave = true
            } else {
                adiView.isPlayingTopWave = true
                adiView.isPlayingMainWave = false
            }
            
            adiView.topSiri.alpha = 1 - opacity * 3
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("Did end dragging")
        let offset = scrollView.contentOffset.y
        if (offset >= Constants.pullOverThreshold * 0.75) {
            scrollView.setContentOffset(CGPoint(x: 0, y: finalPullOverOffset() - 22), animated: true)
        } else {
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
}
