//
//  ClassesStore.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Foundation
import UserDefaultsStore

class LectureStore {

    static var lectures: UserDefaultsStore<LectureDocument> {
        return UserDefaultsStore<LectureDocument>(uniqueIdentifier: "lectures")!
    }
    
}
