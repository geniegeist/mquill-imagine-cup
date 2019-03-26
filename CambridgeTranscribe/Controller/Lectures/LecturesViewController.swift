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
    private var transcripts: [TranscriptDocument] {
        return TranscriptStore.transcripts.allObjects().sorted(by: {$0.date.compare($1.date) == .orderedDescending})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgb: 0xFAB943)
        
        collectionView.register(UINib(nibName: "LectureCell", bundle: nil), forCellWithReuseIdentifier: "lectureCell")
        collectionView.register(UINib(nibName: "LectureHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        let favouritesVC = UINib(nibName: "FavouritesViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! FavouritesViewController
        let navVC = UINavigationController(rootViewController: favouritesVC)
        navVC.navigationBar.isHidden = true
        present(navVC, animated: true, completion: nil)
    }
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Lectures", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        present(vc, animated: true, completion: nil)
    }
}

extension LecturesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return transcripts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lectureCell", for: indexPath) as! LectureCell
        
        let transcript = transcripts[indexPath.item]
        let lecture = LectureStore.lectures.object(withId: transcript.lectureId)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy - HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: transcript.date)
        cell.headlineLabel.text = transcript.title
        cell.transcriptIconView.color = lecture.color
        cell.transcriptIconViewTitleLabel.text = lecture.shortName
        
        if (transcript.keywords.count > 3) {
            cell.tags = Array(transcript.keywords[0...2])
        } else {
            cell.tags = transcript.keywords
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        return header
    }
    
    // Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transcript = transcripts[indexPath.item]
        let lecture = LectureStore.lectures.object(withId: transcript.lectureId)!

        let transcriptVC = UIStoryboard(name: "Transcript", bundle: nil).instantiateInitialViewController() as! TranscriptViewController
        transcriptVC.delegate = self
        transcriptVC.transcript = transcript
        transcriptVC.color = lecture.color
        
        let navigationVC = UINavigationController(rootViewController: transcriptVC)
        navigationVC.navigationBar.isHidden = true
        present(navigationVC, animated: true)
    }
    
    // Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension LecturesViewController: TranscriptViewControllerDelegate {
    
    func transcriptViewController(_ vc: TranscriptViewController, didChange transcript: TranscriptDocument) {
        try! TranscriptStore.transcripts.save(transcript)
    }
    
}
