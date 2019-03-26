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

    
    static func findLecturesWith(name: String) -> [LectureDocument] {
        let lectures = LectureStore.lectures.allObjects()
        let name = name.lowercased()
        return lectures.filter({ $0.shortName.lowercased() == name || $0.name.lowercased().distanceLevenshtein(between: name) <= 3 || $0.name.lowercased().contains(name) || name.contains($0.name.lowercased()) })
    }
    
    static func findLecturesWith(dateStr: String) -> [LectureDocument]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateStr) {
            let lectures = LectureStore.lectures.allObjects()
            return lectures.filter({ $0.date == date })
        } else {
            return nil
        }
    }
    
    static func findLecturesWith(name: String?, dateStr: String?) -> [LectureDocument]? {
        if (name == nil && dateStr != nil) {
            return LectureStore.findLecturesWith(dateStr: dateStr!)
        }
        
        if (name != nil && dateStr == nil) {
            return LectureStore.findLecturesWith(name: name!)
        }
        
        let lectures = LectureStore.lectures.allObjects()
        
        if (name != nil && dateStr != nil) {
            let inter = lectures.filter({ $0.shortName.lowercased() == name?.lowercased() || $0.name.lowercased().distanceLevenshtein(between: name!.lowercased()) <= 3 || name!.lowercased().contains($0.name.lowercased()) || $0.name.lowercased().contains(name!.lowercased())})
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: dateStr!) {
                return inter.filter({ $0.date == date })
            } else {
                return nil
            }
        }
        
        return nil
    }
}
