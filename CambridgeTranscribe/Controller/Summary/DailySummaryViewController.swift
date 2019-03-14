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
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DailySummaryCell
        
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
}
