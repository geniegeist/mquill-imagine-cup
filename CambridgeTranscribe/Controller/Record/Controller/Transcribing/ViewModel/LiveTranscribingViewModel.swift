//
//  LiveTranscribingViewModel.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import ActiveLabel

struct LiveTranscriptFragmentViewModel {
    let fragment: LiveTranscriptFragment
    
    var attributedString: NSAttributedString {
        let content = fragment.content
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.brandonGrotesque(weight: .regular, size: 17),
                          NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x504F5F)]
        return NSAttributedString(string: content, attributes: attributes)
    }
    
    var keywordTypes: [ActiveType] {
        return fragment.keyPhrases.map({ keyPhrase in
            return ActiveType.custom(pattern: "\\s\(keyPhrase)\\b")
        })
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: fragment.date)
    }
    
    init(fragment: LiveTranscriptFragment) {
        self.fragment = fragment
    }
    
}
