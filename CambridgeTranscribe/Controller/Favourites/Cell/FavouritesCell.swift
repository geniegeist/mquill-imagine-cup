//
//  FavouritesCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class FavouritesCell: UITableViewCell {
    @IBOutlet weak var icon: TranscriptIconView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transcriptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        layer.masksToBounds = false
        
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 16
        mainView.layer.shadowColor = UIColor(rgb: 0x0036FF).cgColor
        mainView.layer.shadowRadius = 24
        mainView.layer.shadowOpacity = 0.08
        
        transcriptLabel.attributedText = NSAttributedString(string: "Englisch-Deutsch-Übersetzungen für Don't spend it all in one place im Online- Wörterbuch dict.cc (Deutschwörterbuch).Englisch-Deutsch-Übersetzungen für Don't spend it all in one place im Online- Wörterbuch dict.cc (Deutschwörterbuch).Englisch-Deutsch-Übersetzungen für Don't spend it all in one place im Online- Wörterbuch dict.cc (Deutschwörterbuch).Englisch-Deutsch-Übersetzungen für Don't spend it all in one place im Online- Wörterbuch dict.cc (Deutschwörterbuch).Englisch-Deutsch-Übersetzungen für Don't spend it all in one place im Online- Wörterbuch dict.cc (Deutschwörterbuch).Englisch-Deutsch-Übersetzungen für Don't spend it all in one place im Online- Wörterbuch dict.cc (Deutschwörterbuch).")
    }
}
