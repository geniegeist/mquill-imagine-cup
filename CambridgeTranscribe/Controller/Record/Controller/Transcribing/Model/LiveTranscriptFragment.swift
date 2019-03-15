//
//  LiveTranscriptFragment.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

struct LiveTranscriptFragment: Equatable {
    
    struct Entity: Equatable {
        let name: String
        let matches: [String]
        let wikipediaId: String?
        let wikipediaUrl: String?
        let bingId: String
        
        static func == (lhs: LiveTranscriptFragment.Entity, rhs: LiveTranscriptFragment.Entity) -> Bool {
            return lhs.name == rhs.name && lhs.matches == rhs.matches && lhs.bingId == rhs.bingId
        }
    }
    
    let id: String
    let date: Date
    var content: String
    var keyPhrases: [String]
    var entities: [Entity]
    
    init(id: String, date: Date = Date(), content: String, keyPhrases: [String] = [], entities: [Entity] = []) {
        self.id = id
        self.date = date
        self.content = content
        self.keyPhrases = keyPhrases
        self.entities = entities
    }
    
    func withContent(_ content: String) -> LiveTranscriptFragment {
        return LiveTranscriptFragment(id: self.id, date:self.date, content: content, keyPhrases: self.keyPhrases, entities: self.entities)
    }
    
    func withKeyPhrases(_ keyPhrases: [String]) -> LiveTranscriptFragment {
        return LiveTranscriptFragment(id: self.id, date: self.date, content: self.content, keyPhrases: keyPhrases, entities: self.entities)
    }
    
    func mergeWithFragment(_ rhs: LiveTranscriptFragment) -> LiveTranscriptFragment {
        let mergedContent = content.count > 0 ? content : rhs.content
        let mergedKeyPhrases = keyPhrases.count > 0 ? keyPhrases : rhs.keyPhrases
        let mergedEntities = entities.count > 0 ? entities : rhs.entities
        return LiveTranscriptFragment(id: rhs.id, date: rhs.date, content: mergedContent, keyPhrases: mergedKeyPhrases, entities: mergedEntities)
    }
    
    static func == (lhs: LiveTranscriptFragment, rhs: LiveTranscriptFragment) -> Bool {
        return lhs.id == rhs.id && lhs.entities.count == rhs.entities.count && lhs.content == rhs.content && rhs.keyPhrases == lhs.keyPhrases
    }
}
