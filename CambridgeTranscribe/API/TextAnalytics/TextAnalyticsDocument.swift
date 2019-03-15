//
//  TextAnalyticsDocument.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

struct TextAnalyticsDocument: Codable {
    let language: String
    let id: String
    let text: String
    
    var dictionary: [String: Any] {
        return ["language": language,
                "id": id,
                "text": text]
    }
    
    init(id: String = UUID().uuidString, text: String, language: String = "en") {
        self.id = id
        self.text = text
        self.language = language
    }
}
