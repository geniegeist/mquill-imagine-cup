//
//  TranscribingViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import LNPopupController
import Dwifft

class TranscribingViewController: UINavigationController {
    
    struct Constants {
        static let maxPopupUtteranceLength = 34
        static let placeholderPopup = "I am listening..."
        static let feedCellReuseIdentifier = "feedCell"
        static let fragmentLengthKeywordThreshold = 20 // start a keyword search when the fragment is longer than 20 words
    }
    
    private var feedView: UITableView!
    private var feeds: [LiveTranscriptFeed] = [] {
        didSet {
            feedCalculator?.sectionedValues = SectionedValues([(0, feeds)])
            
            let row = feedCalculator!.numberOfObjects(inSection: 0) - 1
            if (row > 0) {
                feedView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
            }
        }
    }
    var feedCalculator: TableViewDiffCalculator<Int,LiveTranscriptFeed>?
    
    private var popupBarController: TranscribingCustomBarViewController!
    private var popupController: TranscribingPopupController!
    
    private var speechToTextObserver: NSKeyValueObservation?
    private lazy var speechToText: CTSpeechToText = {
        let stt = CTSpeechToText()
        speechToTextObserver = stt.observe(\.isPlaying) { (speechToText, change) in
            DispatchQueue.main.async {
                self.isTranscribing = speechToText.isPlaying
            }
        }
        stt.delegate = self
        return stt
    }()
    private lazy var textAnalytics: TextAnalytics = {
       return TextAnalytics()
    }()
    private lazy var entitySearch: EntitySearch = {
        return EntitySearch()
    }()
    
    private var fragments: [LiveTranscriptFragment] = [] {
        didSet {
            // also called when a new element is appended to the array
            popupController.fragments = fragments
        }
    }
    
    private var currentFragment: LiveTranscriptFragment? {
        didSet {
            guard let content = currentFragment?.content else { return }
            popupBarController.setContent(content)
        }
    }
    
    private var isTranscribing: Bool = false {
        didSet {
            popupController.isTranscribing = isTranscribing
            popupBarController.playButton.isPlaying = isTranscribing
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        view.backgroundColor = UIColor(rgb: 0xFBFBFF)
        
        popupController = TranscribingPopupController.createFromNib()
        popupController.fragments = fragments
        popupController.delegate = self
        
        popupBarController = TranscribingCustomBarViewController.createFromNib()
        popupBarController.setContent(Constants.placeholderPopup, animated: false)
        popupInteractionStyle = .drag
        popupBar.customBarViewController = popupBarController
        popupBar.clipsToBounds = false
        presentPopupBar(withContentViewController: popupController, animated: true, completion: nil)
        
        feedView = UITableView(frame: view.bounds)
        feedView.backgroundColor = UIColor.clear
        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(UINib(nibName: "TranscribingFeedCell", bundle: nil), forCellReuseIdentifier: Constants.feedCellReuseIdentifier)
        feedView.rowHeight = UITableView.automaticDimension
        feedView.estimatedRowHeight = 250
        feedView.separatorStyle = .none
        feedView.tableFooterView = UIView()
        feedView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 64, right: 0)
        view.addSubview(feedView)
        
        feedCalculator = TableViewDiffCalculator(tableView: feedView, initialSectionedValues: SectionedValues([(0, feeds)]))
        feedCalculator?.insertionAnimation = .fade
        feedCalculator?.deletionAnimation = .fade
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        speechToText.startRecognizing()
    }

}

extension TranscribingViewController: CTSpeechToTextDelegate {
    
    // is recognizing
    func speech(_ speechToText: CTSpeechToText,
                isReconigizingUtterance utterance: String,
                utteranceId: String) {
        DispatchQueue.main.async {
            if let currentFragment = self.currentFragment {
                self.currentFragment = currentFragment.withContent(utterance)
            } else {
                self.currentFragment = LiveTranscriptFragment(id: UUID().uuidString, content: utterance)
            }
        }
    }
    
    // did recognize
    func speech(_ speechToText: CTSpeechToText,
                didRecognizeUtterance utterance: String,
                utteranceId: String) {
        DispatchQueue.main.async {
            if let currentFragment = self.currentFragment {
                self.fragments.append(currentFragment.withContent(utterance))
                self.currentFragment = nil
            }
        }
        
        if let currentFragment = self.currentFragment, currentFragment.content.count >= Constants.fragmentLengthKeywordThreshold {
            let analyticsDocument = TextAnalyticsDocument(id: currentFragment.id, text: utterance, language: "en")
            
            textAnalytics.keyphrases(of: [analyticsDocument]) { keyphrases in
                DispatchQueue.main.async {
                    let keyStrings: [String] = keyphrases.map({ $0.content })
                    let index = self.fragments.firstIndex(where: { $0.id == currentFragment.id })!
                    self.fragments[index] = self.fragments[index].withKeyPhrases(keyStrings)
                }
            }
            
            textAnalytics.entities(of: [analyticsDocument]) { entities in
                DispatchQueue.main.async {
                    let entities: [TextAnalytics.Result.Entity] = entities
                    
                    for entity in entities {
                        let query = entity.name
                        let bingId = entity.bingId
                        self.entitySearch.query(query, bingId: bingId) { searchResult in
                            let searchResult: [EntitySearch.Result.Entity] = searchResult
                            self.feeds += [LiveTranscriptFeed(entity: entity, entitySearchResult: searchResult)]
                        }
                    }
                }
            }
        }
    }
    
    func speech(toTextDidCancel speechToText: CTSpeechToText) { }
}

extension TranscribingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedCalculator?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedCalculator?.numberOfObjects(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.feedCellReuseIdentifier, for: indexPath) as! TranscribingFeedCell
        
        let feed = feedCalculator!.value(atIndexPath: indexPath)
        cell.titleLabel.text = feed.entity.name
        
        if let description = feed.entitySearchResult.first?.entityDescription {
            cell.contentLabel.text = description
        } else {
            cell.contentLabel.text = "No description"
        }

        return cell
    }
}

extension TranscribingViewController: TranscribingPopupControllerDelegate {
    func transcribingPopupControllerPlayButtonTapped(_ popupController: TranscribingPopupController) {
        if (speechToText.isPlaying) {
            self.isTranscribing = false // optimistic UI
            DispatchQueue.global(qos: .default).async {
                self.speechToText.stopRecognizing()
            }
        } else {
            speechToText.startRecognizing()
        }
    }
}
