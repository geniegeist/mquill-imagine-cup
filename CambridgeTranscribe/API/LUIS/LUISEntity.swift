//
//  LUISEntity.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

struct LUISEntity {

    let entity: String
    let type: String
    let startIndex: Int
    let endIndex: Int
    let dateValue: String?
    
    static func from(json: Dictionary<String, Any>) -> LUISEntity {
        let resolution = json["resolution"] as? Dictionary<String, Any>
        let value = (resolution?["values"] as? Array<[String:Any]>)?.first
        let dateValue = value?["value"] as? String
        return LUISEntity(entity: json["entity"] as! String, type: json["type"] as! String, startIndex: json["startIndex"] as! Int, endIndex: json["endIndex"] as! Int, dateValue: dateValue)
    }
    
}
