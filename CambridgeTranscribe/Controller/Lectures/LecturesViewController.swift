//
//  LecturesViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 09.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import UserDefaultsStore

class LecturesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var transcripts: UserDefaultsStore<TranscriptDocument> {
        return TranscriptStore.transcripts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgb: 0xFAB943)
        
        collectionView.register(UINib(nibName: "LectureCell", bundle: nil), forCellWithReuseIdentifier: "lectureCell")
        collectionView.register(UINib(nibName: "LectureHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor.clear
    }
}

extension LecturesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return transcripts.allObjects().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lectureCell", for: indexPath) as! LectureCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        return header
    }
    
    // Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transcriptVC = UIStoryboard(name: "Transcript", bundle: nil).instantiateInitialViewController() as! TranscriptViewController
        transcriptVC.delegate = self
        transcriptVC.transcript = transcripts.allObjects()[indexPath.item]
        
        let navigationVC = UINavigationController(rootViewController: transcriptVC)
        navigationVC.navigationBar.isHidden = true
        present(navigationVC, animated: true)
    }
    
    // Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: 120)
    }
}

extension LecturesViewController: TranscriptViewControllerDelegate {
    
    func transcriptViewController(_ vc: TranscriptViewController, didChange transcript: TranscriptDocument) {
        try! transcripts.save(transcript)
    }
    
}
