//
//  LUIS.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 18.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class LUIS {
    
    struct Response {
        let query: String?
        let topScoringIntent: LUISIntent?
        let intents: [LUISIntent]?
        let entities: [LUISEntity]?
        
        static func from(json: Dictionary<String, Any>) -> Response {
            let jsonIntents = json["intents"] as? [Dictionary<String, Any>]
            let jsonEntities = json["entities"] as? [Dictionary<String, Any>]
            let intents: [LUISIntent]? = jsonIntents?.map({ LUISIntent.from(json: $0)})
            let entities = jsonEntities?.map({ LUISEntity.from(json: $0) })
            let topScoringIntent = json["topScoringIntent"] as? Dictionary<String, Any>
            
            return Response(query: json["query"] as? String,
                            topScoringIntent: topScoringIntent != nil ? LUISIntent.from(json: topScoringIntent!) : nil,
                            intents: intents,
                            entities: entities)
        }
    }
    
    func intentFrom(_ text: String, handler: ((Response) -> Void)?) {
        let headers: HTTPHeaders = [:]
        let parameters = ["q": text]
        let url = "https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/a3f3bc15-910e-4441-a77b-be2ae672bd42?verbose=true&timezoneOffset=-360&subscription-key=f540ea2363544741a4c1dc1d61db4801"
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (jsonResponse) in
            let response = Response.from(json: jsonResponse.result.value as! [String:Any])
            if let handler = handler {
                handler(response)
            }
        }
    }
    
}
