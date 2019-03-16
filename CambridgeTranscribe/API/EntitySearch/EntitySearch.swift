//
//  EntitySearch.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import Alamofire

class EntitySearch {

    struct Result {
        struct Entity {
            enum Hint: String {
                case person = "Person"
                case generic = "Generic"
                case place = "Place"
                case media = "Media"
                case organization = "Organization"
                
                // education
                case speciality = "Speciality"
                
                case unknown = "unknown"
                
                static func from(string: String) -> Hint {
                    let res = Hint(rawValue: string)
                    if let k = res {
                        return k
                    } else {
                        return Hint.unknown
                    }
                }
            }
            
            
            let bingId: String
            let entityDescription: String?
            let webSearchUrl: String
            let name: String?
            let url: String?
            let hints: [Hint]?
            let displayHint: String?
            let imageUrl: String?
            let licenseAttribution: String?
            
            static func from(dictionary: Dictionary<String, Any?>) -> Entity {
                let entityPresentationInfo = dictionary["entityPresentationInfo"] as? [String:Any?]
                let entityTypeHints = entityPresentationInfo?["entityTypeHints"] as? [String]
                let displayHint = entityPresentationInfo?["entityTypeDisplayHint"] as? String
                let image = dictionary["image"] as? [String:Any?]
                let contractualRules = dictionary["contractualRules"] as? [Dictionary<String, Any>]
                let contractualRulesObj = contractualRules?.first(where: { (dict) -> Bool in
                    let _type = dict["_type"] as? String?
                    return _type == "ContractualRules/LicenseAttribution"
                })
                
                return Entity(
                    bingId: dictionary["bingId"] as! String,
                    entityDescription: dictionary["description"] as? String,
                    webSearchUrl: dictionary["webSearchUrl"] as! String,
                    name: dictionary["name"] as? String,
                    url: dictionary["url"] as? String,
                    hints: entityTypeHints?.map({ Hint.from(string: $0) }),
                    displayHint: displayHint,
                    imageUrl: image?["hostPageUrl"] as? String,
                    licenseAttribution: contractualRulesObj?["licenseNotice"] as? String
                )
            }
        }
        
        
    }
    
    private let endpoint = "https://api.cognitive.microsoft.com/bing/v7.0/entities/"
    
    private let apiKey: String
    private let market: String = "en-us"
    
    init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path)!
        apiKey = plist["entitySearchApiKey"] as! String
    }
    
    func query(_ query: String, bingId: String? = nil, handler: ( ([EntitySearch.Result.Entity]) -> Void)?) {
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": apiKey
        ]
        
        let parameters = ["q" : query, "mkt" : market]
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            guard let json = response.result.value as? [String: Any?] else {
                if let completionHandler = handler {
                    completionHandler([]) // nothing found
                }
                return
            }
            
            guard let entities = json["entities"] as? Dictionary<String, Any?> else {
                if let completionHandler = handler {
                    completionHandler([]) // nothing found
                }
                return
            }
            guard let values = entities["value"] as? [Dictionary<String, Any?>] else { return }
            
            let entityResults = values.map({ Result.Entity.from(dictionary: $0) })
  
            if let completionHandler = handler {
                completionHandler(entityResults)
            }
            
        }
    }

}
