//
//  TranscriptDocument.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Foundation
import UserDefaultsStore

enum TranscriptTagName: String, Codable {
    case marking = "marking"
    case keyword = "keyword"
}

struct TranscriptTag: Codable {
    var name: TranscriptTagName
    var range: NSRange
    
    init(name: TranscriptTagName, range: NSRange) {
        self.name = name
        self.range = range
    }
}

struct TranscriptFragment: Codable {
    var id: String
    var date: Date
    var content: String
    var isFavourite: Bool
    var tags: [TranscriptTag]
    
    init(id: String = UUID().uuidString,
         content: String,
         isFavourite: Bool,
         date: Date = Date(),
         tags: [TranscriptTag] = []) {
        self.id = id
        self.content = content
        self.isFavourite = isFavourite
        self.date = date
        self.tags = tags
    }
}

struct TranscriptDocument: Codable, Identifiable {
    var id: String
    var title: String
    var date: Date
    var sequence: Int
    var fragments: [TranscriptFragment]
    var lectureId: String
    
    init(id: String = UUID().uuidString,
         title: String,
         sequence: Int,
         fragments: [TranscriptFragment],
         date: Date = Date(),
         lectureId: String) {
        self.id = id
        self.title = title
        self.sequence = sequence
        self.date = date
        self.fragments = fragments
        self.lectureId = lectureId
    }
    
    var keywords: [String] {
        var res = [String]()
        for frag in fragments {
            let tags = frag.tags.filter({ $0.name == .keyword })
            res += tags.map({ String(frag.content.substring(with: $0.range )!) })
        }
        return res
    }
    
    static let idKey = \TranscriptDocument.id
}
