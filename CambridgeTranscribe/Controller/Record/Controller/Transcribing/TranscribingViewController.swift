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
import Kingfisher // Image download library
import Hero
import FFPopup
import AVFoundation

class TranscribingViewController: UINavigationController {
    
    struct Constants {
        static let maxPopupUtteranceLength = 34
        static let placeholderPopup = "I am listening..."
        static let feedCellReuseIdentifier = "feedCell"
        static let fragmentLengthKeywordThreshold = 20 // start a keyword search when the fragment is longer than 20 words
    }
    
    private typealias BingId = String
    
    private var feedView: UITableView!
    private var feeds: [LiveTranscriptFeed] = [] {
        didSet {
            feedCalculator?.sectionedValues = SectionedValues([(0, feeds)])
            /*
             let row = feedCalculator!.numberOfObjects(inSection: 0) - 1
            
            if (row > 0 && !userIsScrolling && !lockerUserContentOffset && oldValue.count > 1) {
                feedView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
            }
 */
        }
    }
    private var processingFeeds: [BingId] = [] {
        didSet {
            
        }
    }
    private var feedCalculator: TableViewDiffCalculator<Int,LiveTranscriptFeed>?
    private var emptyFeedView: UIView?
    private var floatingActivityFeedIndicator: FloatingActivityFeedIndicator!
    
    private var dismissButton: UIButton!
    
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
            if let fragment = currentFragment {
                popupBarController.setContent(fragment.content)
            }
        }
    }
    
    private var isTranscribing: Bool = false {
        didSet {
            floatingActivityFeedIndicator.isPlaying = isTranscribing
            popupController.isTranscribing = isTranscribing
            popupBarController.playButton.isPlaying = isTranscribing
        }
    }
    
    private var userIsScrolling: Bool = false
    private var lockerUserContentOffset: Bool = false
    
    private var saveTranscriptViewController: SaveTranscriptViewController?

    private var audioRecorder: AVAudioRecorder!
    var siriDisplayLink: CADisplayLink!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        hero.modalAnimationType = .autoReverse(presenting: .push(direction: .up))
        navigationBar.isHidden = true

        view.backgroundColor = UIColor(rgb: 0xFBFBFF)
        
        popupController = TranscribingPopupController.createFromNib()
        popupController.fragments = fragments
        popupController.floatingSaveButton.addTarget(self, action: #selector(presentSaveTranscriptViewController), for: .touchUpInside)
        popupController.floatingDiscardButton.addTarget(self, action: #selector(dismissTCVC), for: .touchUpInside)
        popupController.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        popupBarController = TranscribingCustomBarViewController.createFromNib()
        popupBarController.setContent(Constants.placeholderPopup, animated: false)
        popupBarController.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        popupBarController.askAdiButton.addTarget(self, action: #selector(askAdiButtonTapped), for: .touchUpInside)
        popupBarController.playButton.isPlaying = true
        
        popupInteractionStyle = .drag
        popupBar.customBarViewController = popupBarController
        popupBar.clipsToBounds = false
        
        feedView = UITableView(frame: view.bounds)
        feedView.backgroundColor = UIColor.clear
        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(UINib(nibName: "TranscribingFeedCell", bundle: nil), forCellReuseIdentifier: Constants.feedCellReuseIdentifier)
        feedView.rowHeight = UITableView.automaticDimension
        feedView.estimatedRowHeight = 250
        feedView.separatorStyle = .none
        feedView.tableFooterView = UINib(nibName: "TranscribingFooter", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        feedView.contentInset = UIEdgeInsets(top: 76, left: 0, bottom: 24, right: 0)
        feedView.allowsSelection = false
        feedView.clipsToBounds = false
        view.addSubview(feedView)
        
        feedCalculator = TableViewDiffCalculator(tableView: feedView, initialSectionedValues: SectionedValues([(0, feeds)]))
        feedCalculator?.insertionAnimation = .fade
        feedCalculator?.deletionAnimation = .fade
        
        let feedIndicatorContainer = UIView(frame: CGRect(x: (feedView.frame.size.width - 250)/2 - 44, y: 48, width: 250+44, height: 32))
        feedIndicatorContainer.layer.shadowColor = UIColor(rgb: 0x000AFF).cgColor
        feedIndicatorContainer.layer.shadowRadius = 16
        feedIndicatorContainer.layer.shadowOpacity = 0.16
        floatingActivityFeedIndicator = UINib(nibName: "FloatingActivityFeedIndicator", bundle: nil).instantiate(withOwner: self, options: nil).first as? FloatingActivityFeedIndicator
        floatingActivityFeedIndicator.frame = feedIndicatorContainer.bounds
        view.addSubview(feedIndicatorContainer)
        feedIndicatorContainer.addSubview(floatingActivityFeedIndicator)
        
        let dismissButtonWidth: CGFloat = 40
        let originx: CGFloat = view.frame.size.width - dismissButtonWidth - 16
        dismissButton = UIButton(frame: CGRect(x: originx, y: feedIndicatorContainer.frame.origin.y - 4, width: dismissButtonWidth, height: dismissButtonWidth))
        dismissButton.setImage(UIImage(named: "close_filled_round"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        view.addSubview(dismissButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        speechToText.startRecognizing()
        presentPopupBar(withContentViewController: popupController, animated: true, completion: nil)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url = paths[0]
        url.appendPathComponent("recordTest.m4a")
        
        let recordSettings: [String : Any] = [
            AVSampleRateKey: 16000.0,
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue
        ]
        
        let audioSession:AVAudioSession = AVAudioSession.init()
        try! audioSession.setCategory(.record, mode: .default)
        audioRecorder = try! AVAudioRecorder(url: url, settings: recordSettings)
        try! audioSession.setActive(true)
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        siriDisplayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
        siriDisplayLink.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc func updateMeters() {
        if (audioRecorder.isRecording) {
            audioRecorder.updateMeters()
            let power = audioRecorder.averagePower(forChannel: 0)
            floatingActivityFeedIndicator.decibels = CGFloat(power)
        }
    }
    
    //MARK: Action
    
    @objc func presentSaveTranscriptViewController() {
        let saveTranscriptViewController = SaveTranscriptViewController.createFromNib()
        self.saveTranscriptViewController = saveTranscriptViewController
        saveTranscriptViewController.saveTranscriptDelegate = self
        
        let navVC = UINavigationController(rootViewController: saveTranscriptViewController)
        navVC.navigationBar.isHidden = true
        navVC.hero.isEnabled = true
        navVC.hero.navigationAnimationType = .autoReverse(presenting: .zoom)
        
        present(navVC, animated: true, completion: {
            self.dismissPopupBar(animated: false)
        })
    }
    
    @objc func dismissTCVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func playButtonTapped() {
        if (speechToText.isPlaying) {
            self.isTranscribing = false // optimistic UI
            if (popupBarController.contentLabel.text == "I am listening...") {
                popupBarController.contentLabel.text = "Resume transcription..."
            }
            DispatchQueue.global(qos: .default).async {
                self.speechToText.stopRecognizing()
                self.audioRecorder.stop()
            }
        } else {
            speechToText.startRecognizing()
            audioRecorder.record()
            
            if (popupBarController.contentLabel.text == "Resume transcription...") {
                popupBarController.contentLabel.text = "I am listening..."
            }
        }
    }
    
    @objc func askAdiButtonTapped() {
        let vc = UIStoryboard(name: "ADI", bundle: nil).instantiateInitialViewController() as! ADIViewController
        vc.context = fragments.map({ $0.content }).joined(separator: " ")
        vc.disableMicrophone = true
        present(vc, animated: true)
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
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
                let entities: [TextAnalytics.Result.Entity] = entities
                    
                for entity in entities {
                    let query = entity.name
                    let bingId = entity.bingId
                    if (!self.processingFeeds.contains(bingId) && !self.feeds.contains(where: { $0.entity.bingId == bingId })) {
                        self.processingFeeds.append(bingId)
                        self.entitySearch.query(query, bingId: bingId) { searchResult in
                            DispatchQueue.main.async {
                                self.processingFeeds.remove(at: self.processingFeeds.firstIndex(of: bingId)!)
                                let searchResult: [EntitySearch.Result.Entity] = searchResult
                                self.feeds += [LiveTranscriptFeed(entity: entity,
                                                                  entitySearchResult: searchResult)]
                            }
                        }
                    }
                }
            }
        }
    }
    
    func speech(toTextDidCancel speechToText: CTSpeechToText) { }
}

extension TranscribingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userIsScrolling = true
        lockerUserContentOffset = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        userIsScrolling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (contentOffset.y >= maxOffset) {
            lockerUserContentOffset = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedCalculator?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedCalculator?.numberOfObjects(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.feedCellReuseIdentifier, for: indexPath) as! TranscribingFeedCell
        cell.selectionStyle = .none
        cell.clipsToBounds = false

        let feed = feedCalculator!.value(atIndexPath: indexPath)
        let entitySearchResult = feed.entitySearchResult.first
        cell.titleLabel.text = feed.entity.name
        
        if let description = entitySearchResult?.entityDescription {
            cell.contentLabel.text = description
        } else {
            cell.contentLabel.text = "No description"
        }
 
        cell.feedIdentifier = feed.entity.bingId
        
        if let imageUrlStr = entitySearchResult?.imageUrl {
            let url = URL(string: imageUrlStr)
            cell.transcriptIconView.isHidden = false
            cell.transcriptIconView.imageView.kf.indicatorType = .activity
            cell.transcriptIconView.imageView.kf.setImage(with: url,
                                                          options:[.transition(.fade(1)), .cacheOriginalImage])
        } else {
            cell.transcriptIconView.isHidden = true
        }
        
        if let copyrightStr = entitySearchResult?.licenseAttribution {
            cell.copyrightLabel.text = copyrightStr
        }
        
        /*
        cell.titleLabel.text = "Taylor Swift"
        cell.contentLabel.text = "It is an important parameter used in science and engineering to specify the rate of oscillatory and vibratory phenomena"
        */
        return cell
    }
}

extension TranscribingViewController: SaveTranscriptViewControllerDelegate {
    func saveTranscript(_: SaveTranscriptViewController, inLecture lectureId: String) {
        let docsWithSameLectureId = TranscriptStore.transcripts.allObjects().filter({ $0.lectureId == lectureId })
        let lecture = LectureStore.lectures.object(withId: lectureId)!
        let sequence = docsWithSameLectureId.count
        
        let fragments: [TranscriptFragment] = self.fragments.map { (liveTranscriptFragment) -> TranscriptFragment in
            let content = liveTranscriptFragment.content
            let date = liveTranscriptFragment.date
            //let tags: [TranscriptTag] = liveTranscriptFragment.keyPhrases.map
            
            var tags: [TranscriptTag] = []
            for keyPhrase in liveTranscriptFragment.keyPhrases {
                let content = liveTranscriptFragment.content
                let occurences: [NSRange] = content.ranges(of: keyPhrase).map({ content.nsRange(from: $0) })
                for range in occurences {
                    tags.append(TranscriptTag(name: TranscriptTagName.keyword, range: range))
                }
            }
            
            return TranscriptFragment(content: content,
                                      isFavourite: false,
                                      date: date,
                                      tags: tags)
        }
        
        let document = TranscriptDocument(title: "#\(sequence) \(lecture.name)",
            sequence: sequence,
            fragments: fragments,
            lectureId: lectureId)
        try! TranscriptStore.transcripts.save(document)
        
        dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
