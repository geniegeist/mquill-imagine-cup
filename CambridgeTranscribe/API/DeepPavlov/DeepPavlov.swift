//
//  DeepPavlov.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class DeepPavlov {
    
    private let endpoint: String
    
    init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path)!
        endpoint = plist["pavlovEndpoint"] as! String
    }
    
    func question(_ question: String, over text: String, handler:((String?) -> Void)?) {
        let headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        
        let parameters = [
            "text1" : [text],
            "text2" : [question]
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (jsonResponse) in
            let res = jsonResponse.result.value as? [[Any]]
            let answer = res?.first?.first as? String
            
            if let handler = handler {
                handler(answer)
            }
        }
    }
    
}
