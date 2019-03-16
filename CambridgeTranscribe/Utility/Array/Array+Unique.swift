//
//  Array+Unique.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
