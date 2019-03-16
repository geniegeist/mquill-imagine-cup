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

class TranscribingPopupController: UIViewController {
    
    struct Constants {
        static let cellIdentifier = "fragment"
        static let paddingBetweenCells: CGFloat = 0
        static let topContentPadding: CGFloat = 20
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: PlayButton!
    lazy var floatingSaveButton: FloatingSaveButton! = {
       return FloatingSaveButton()
    }()
    lazy var floatingDiscardButton: FloatingDiscardButton! = {
        return FloatingDiscardButton()
    }()
    
    private var tableViewEmptyLabel: UILabel?
    private var tableViewEmptyView: UIView?
    
    var isTranscribing: Bool = false {
        didSet {
            playButton.isPlaying = isTranscribing
            
            if (isTranscribing) {
                floatingSaveButton.dismiss()
                floatingDiscardButton.dismiss()
            } else {
                let destFrame = CGRect(x: (view.bounds.size.width - floatingSaveButton.frame.size.width - 24)/2, y: playButton.frame.minY - 66, width: floatingSaveButton.frame.size.width + 24, height: 50)
                floatingSaveButton.presentInView(view, frame: destFrame)
                let destFrameDis = CGRect(x: (view.bounds.size.width - 120)/2, y: playButton.frame.minY + 78, width: 120, height: 36)
                floatingDiscardButton.presentInView(view, frame: destFrameDis)
            }
        }
    }
    
    var fragments: [LiveTranscriptFragment] = [] {
        didSet {
            if (fragments.count > 0) {
                tableViewEmptyView?.removeFromSuperview()
                tableViewEmptyView = nil
            }
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
        playButton.size = .large
        
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
        tableView.clipsToBounds = true
        
        tableViewEmptyView = UIView(frame: CGRect(x: 0, y: -Constants.topContentPadding, width: tableView.bounds.size.width, height: tableView.frame.size.height))
        let imageView = UIImageView(frame: tableViewEmptyView!.bounds.offsetBy(dx: 0, dy: -20))
        imageView.image = UIImage(named: "empty-transcript")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        tableViewEmptyView?.addSubview(imageView)
        tableView.addSubview(tableViewEmptyView!)
        
        tableViewEmptyLabel = UILabel(frame: CGRect(x: 0, y: 320, width: tableView.bounds.size.width, height: 50))
        tableViewEmptyLabel?.text = "The transcript is currently empty."
        tableViewEmptyLabel?.font = UIFont.brandonGrotesque(weight: .mediumItalic, size: 20)
        tableViewEmptyLabel?.textColor = UIColor(white: 0, alpha: 0.3)
        tableViewEmptyLabel?.textAlignment = .center
        tableViewEmptyView?.addSubview(tableViewEmptyLabel!)
        
        diffCalculator = TableViewDiffCalculator(tableView: tableView, initialSectionedValues: SectionedValues([(0, fragments)]))
        diffCalculator?.insertionAnimation = .fade
        diffCalculator?.deletionAnimation = .fade        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
