//
//  ClassDocument.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Foundation
import UserDefaultsStore


struct LectureDocument: Codable, Identifiable {
    static let idKey = \LectureDocument.id
    
    enum Color: String, Codable {
        case magenta = "magenta"
        case turquoise = "turquoise"
        case orange = "orange"
    }
    
    var id: String
    let shortName: String
    let name: String
    let color: Color
    let date: Date
    
    init(id: String = UUID().uuidString,
         shortName: String,
         name: String,
         color: Color,
         date: Date = Date()) {
        self.id = id
        self.shortName = shortName
        self.name = name
        self.color = color
        self.date = date
    }
    
}
