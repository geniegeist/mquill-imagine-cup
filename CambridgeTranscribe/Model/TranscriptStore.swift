//
//  TranscriptStore.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Foundation
import UserDefaultsStore

class TranscriptStore {
    
    static var transcripts: UserDefaultsStore<TranscriptDocument> {
        return UserDefaultsStore<TranscriptDocument>(uniqueIdentifier: "transcripts")!
    }

}
