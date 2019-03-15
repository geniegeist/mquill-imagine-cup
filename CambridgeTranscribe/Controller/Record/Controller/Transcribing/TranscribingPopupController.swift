//
//  TranscribingPopupController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 13.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Dwifft
import ActiveLabel

protocol TranscribingPopupControllerDelegate {
    func transcribingPopupControllerPlayButtonTapped(_ popupController: TranscribingPopupController)
}

class TranscribingPopupController: UIViewController {
    
    struct Constants {
        static let cellIdentifier = "fragment"
        static let paddingBetweenCells: CGFloat = 0
        static let topContentPadding: CGFloat = 20
    }
    
    var delegate: TranscribingPopupControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: PlayButton!
    
    var isTranscribing: Bool = false {
        didSet {
            playButton.isPlaying = isTranscribing
        }
    }
    
    var fragments: [LiveTranscriptFragment] = [] {
        didSet {
            /*
            let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
            if (indexPath.row > 0 && oldValue.count != fragments.count) {
                //tableView.insertRows(at: [indexPath], with: .bottom)
                //tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                tableView.reloadSections([0], with: .top)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            } else {
                tableView.reloadData()
            }
             */
            diffCalculator?.sectionedValues = SectionedValues([(0, fragments)])

            let row = diffCalculator!.numberOfObjects(inSection: 0) - 1
            if (row > 0) {
                tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
            }
        }
    }
    
    var diffCalculator: TableViewDiffCalculator<Int,LiveTranscriptFragment>?
    
    var cellHeightsDictionary: [IndexPath: CGFloat] = [:]

    
    class func createFromNib() -> TranscribingPopupController {
        return UINib(nibName: "TranscribingPopupController", bundle: nil).instantiate(withOwner: self, options: nil).first as! TranscribingPopupController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        titleLabel.font = UIFont.brandonGrotesque(weight: .bold, size: 24)
        titleLabel.textColor = UIColor(rgb: 0x504F5F)
        titleLabel.text = "Transcript"
        
        tableView.backgroundColor = UIColor(rgb: 0xF6F6F6)
        tableView.layer.cornerRadius = 12
        tableView.register(UINib(nibName: "TranscribingPopupFragmentCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: Constants.topContentPadding, left: 0, bottom: 12, right: 0)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.clipsToBounds = false
        
        diffCalculator = TableViewDiffCalculator(tableView: tableView, initialSectionedValues: SectionedValues([(0, fragments)]))
        diffCalculator?.insertionAnimation = .fade
        diffCalculator?.deletionAnimation = .fade
    }

    //MARK: Action
    @IBAction func playButtonTapped(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.transcribingPopupControllerPlayButtonTapped(self)
        }
    }
}
extension TranscribingPopupController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diffCalculator?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diffCalculator?.numberOfObjects(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TranscribingPopupFragmentCell
        
        let fragment = diffCalculator!.value(atIndexPath: indexPath)
        let viewModel = LiveTranscriptFragmentViewModel(fragment: fragment)
        
        cell.contentLabel.enabledTypes = viewModel.keywordTypes
        for customType in viewModel.keywordTypes {
            cell.contentLabel.customColor[customType] = UIColor(rgb: 0xE47627)
            cell.contentLabel.customSelectedColor[customType] = UIColor(rgb: 0x89481A)
            cell.contentLabel.handleCustomTap(for: customType) { keyword in
                print("\(keyword) tapped")
            }
        }
        
        cell.dateLabel.text = viewModel.date
        cell.contentLabel.attributedText = viewModel.attributedString
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // print("Cell height: \(cell.frame.size.height)")
        self.cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.cellHeightsDictionary[indexPath] {
            return height
        }
        return UITableView.automaticDimension
    }
}
