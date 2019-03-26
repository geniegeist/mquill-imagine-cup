//
//  DailySummaryViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 12.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class DailySummaryViewController: UIViewController {
    
    struct Constants {
        static let containerTopInset: CGFloat = 120
    }

    @IBOutlet weak var collectionViewContainerScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var collectionViewOriginFrame: CGRect {
        // return CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - collectionViewContainerScrollView.frame.minY)
        return CGRect(x: 0, y: 0, width: view.bounds.size.width, height: collectionView.contentSize.height)
    }
    
    var results: [String] = [
        "MQuill: Lecture Capture, smart search, Q and A, a scroll away",
        "So Todd talked about doing customer discovery. This is a tool to help you do that. Who has heard of minimum viable product?. It is not a prototype.",
        "Thomas John Thomson (August 5, 1877) was a Canadian artist active in the early 20th century.",
        "Let’s see, one is that Homework 1 will be due Thursday"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.white
        collectionView.layer.cornerRadius = 32
        collectionView.showsVerticalScrollIndicator = false
        collectionView.frame = collectionViewOriginFrame
        
        collectionView.isScrollEnabled = false
        collectionViewContainerScrollView.contentInset = UIEdgeInsets(top: Constants.containerTopInset, left: 0, bottom: 0, right: 0)
        collectionViewContainerScrollView.delegate = self
        collectionViewContainerScrollView.alwaysBounceVertical = true
        collectionViewContainerScrollView.contentSize = CGSize(width: view.bounds.size.width, height: collectionView.contentSize.height + Constants.containerTopInset)
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = collectionViewOriginFrame
        collectionViewContainerScrollView.contentSize = CGSize(width: view.bounds.size.width, height: collectionView.contentSize.height + Constants.containerTopInset)

    }

}

extension DailySummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DailySummaryCell
        
        let result = results[indexPath.row]
        cell.titleLabel.text = result
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        print(offset)
        print(collectionView.contentSize.height)
        
        if (offset <= 0 && scrollView == collectionViewContainerScrollView) {
            collectionView.setContentOffset(.zero, animated: false)
        } else if (offset > 0) {
            collectionView.frame = collectionViewOriginFrame.offsetBy(dx: 0, dy: offset)
            collectionView.setContentOffset(scrollView.contentOffset, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.row
        var identifier = "w353454-01"
        if (idx == 0) {
            identifier = "w353454-01"
        } else if (idx == 1) {
            identifier = "1"
        } else if (idx == 2) {
            identifier = "2"
        } else {
            identifier = "5"
        }
        
        let vc = UIStoryboard(name: "Transcript", bundle: nil).instantiateInitialViewController() as! TranscriptViewController
        
        let lol = TranscriptStore.transcripts.allObjects()
        let store = TranscriptStore.transcripts.object(withId: identifier)!
        
        vc.transcript = store
        
        present(vc, animated: true, completion: nil)
    }
}
