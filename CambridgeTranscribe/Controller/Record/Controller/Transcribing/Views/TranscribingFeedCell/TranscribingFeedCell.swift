//
//  TranscribingFeedCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import ActiveLabel

class TranscribingFeedCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: ActiveLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear

        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor.white
        mainView.layer.shadowRadius = 24
        mainView.layer.shadowColor = UIColor(rgb: 0x0036FF).cgColor
        mainView.layer.shadowOpacity = 0.08
        mainView.layer.shadowOffset = .zero
        mainView.clipsToBounds = false
        
        contentLabel.numberOfLines = 0
        contentLabel.text = "nsfjnsk sjkd fjks fjksd fkjs fjks fh sdhjf shjf jhs fhjs fhsd hfjhs jfhs"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
