//
//  LUISIntent.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

struct LUISIntent {
    let intent: Identifier?
    let score: Double?
    
    enum Identifier: String {
        case none = "None"
        case findClass = "FindClass"
        case findKeywords = "FindKeywords"
        case findTranscript = "FindTranscript"
    }
    
    static func from(json: Dictionary<String, Any>) -> LUISIntent {
        return LUISIntent(intent: Identifier(rawValue:json["intent"] as! String), score: json["score"] as? Double)
    }
}
