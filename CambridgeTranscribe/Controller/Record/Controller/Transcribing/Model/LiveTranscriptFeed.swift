//
//  LiveTranscriptFeed.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

struct LiveTranscriptFeed: Equatable {
    let entity: TextAnalytics.Result.Entity
    let entitySearchResult: [EntitySearch.Result.Entity]
        
    public static func == (lhs: LiveTranscriptFeed, rhs: LiveTranscriptFeed) -> Bool {
        return lhs.entity.bingId == rhs.entity.bingId
    }
}
