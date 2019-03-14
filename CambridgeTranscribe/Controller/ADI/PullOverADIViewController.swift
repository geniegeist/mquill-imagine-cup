//
//  PullOverADIViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 11.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class PullOverADIViewController: PullOverViewController {
    
    struct Constants {
        static let expandedChildHeight: CGFloat = 264
        static let shrinkedChildHeight: CGFloat = 120
    }
    
    var pullOverADIView: PullOverADIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // _debug()
        
        pullOverADIView = UINib(nibName: "PullOverADIView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PullOverADIView
        contentView = pullOverADIView
        
        /*
        let bottomBGView = UIView(frame: CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 500))
        bottomBGView.backgroundColor = UIColor(rgb: 0x2A2A49)
        scrollView.insertSubview(bottomBGView, at: 0)
        */
        
        childHeight = Constants.expandedChildHeight
        dismissThreshold = 240
    }
    
    @objc func waitingSpeech() {
        print("wait")
        pullOverADIView.setStateToWaitingForSpeech()
        childHeight = Constants.expandedChildHeight
    }
    
    @objc func processSpeech() {
        print("process speech")
        pullOverADIView.setStateToProcessingSpeech(userSpeech: "Hey give me all lectures about  fuisdf sidhft")
        childHeight = Constants.expandedChildHeight
    }
    
    @objc func processRequest() {
        print("process request")
        pullOverADIView.setStateToProcessingRequest(request: "Okay I will process it")
        childHeight = Constants.expandedChildHeight
    }
    
    @objc func finishedState() {
        print("finished state")
        pullOverADIView.setStateToFinished(message: "This is what I have found")
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.childHeight = Constants.shrinkedChildHeight
        }, completion: nil)
        /*
        let destFrame = CGRect(x: pullOverADIView.frame.origin.x, y: pullOverADIView.frame.origin.y, width: pullOverADIView.frame.size.width)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            pullOverADIView.frame = CGRect(x: )
        }) { (complete) in
            
        }
        */
    }
    
    //MARK: Debug
    
    private func _debug() {
        let waiting = UIButton(frame: CGRect(x: 0, y: 200, width: 300, height: 50))
        waiting.setTitle("Waiting for user speech", for: .normal)
        waiting.addTarget(self, action: #selector(waitingSpeech), for: .touchUpInside)
        view.addSubview(waiting)
        
        let processingSpeech = UIButton(frame: CGRect(x: 0, y: 250, width: 300, height: 50))
        processingSpeech.setTitle("Processing for user speech", for: .normal)
        processingSpeech.addTarget(self, action: #selector(processSpeech), for: .touchUpInside)
        view.addSubview(processingSpeech)
        
        let processingRequest = UIButton(frame: CGRect(x: 0, y: 300, width: 300, height: 50))
        processingRequest.setTitle("Processing for user request", for: .normal)
        processingRequest.addTarget(self, action: #selector(processRequest), for: .touchUpInside)
        view.addSubview(processingRequest)
        
        let finishedBtn = UIButton(frame: CGRect(x: 0, y: 350, width: 300, height: 50))
        finishedBtn.setTitle("Finish", for: .normal)
        finishedBtn.addTarget(self, action: #selector(finishedState), for: .touchUpInside)
        view.addSubview(finishedBtn)
    }
}
