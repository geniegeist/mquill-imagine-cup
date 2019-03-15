//
//  TextAnalytics.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 14.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class TextAnalytics {
    
    static let filteredKeyPhrases = ["i'm"]
    
    struct Result {
        struct KeyPhrase: Codable {
            let documentId: String
            let content: String
            
            /*
            init(from dictionary: Dictionary<String,Any>) {
                self.id = dictionary["id"] as! String
                self.keyphrases = dictionary["keyPhrases"] as! [String]
            }
            */
        }
        
        struct Entity {
            let documentId: String
            let name: String
            let matches: [String]
            let wikipediaId: String?
            let wikipediaUrl: String?
            let bingId: String
            
            static func from(documentId: String, dictionary: Dictionary<String, Any>) -> Entity {
                let matches = dictionary["matches"] as! [Dictionary<String, Any>]
                return Entity(documentId: documentId,
                              name: dictionary["name"] as! String,
                              matches: matches.map({ $0["text"] as! String }),
                              wikipediaId: dictionary["wikipediaId"] as? String,
                              wikipediaUrl: dictionary["wikipediaUrl"] as? String,
                              bingId: dictionary["bingId"] as! String)
            }
        }
    }
    
    struct Constants {
        struct Endpoint {
            static let keyPhrases = "https://uksouth.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases"
            static let entities = "https://uksouth.api.cognitive.microsoft.com/text/analytics/v2.0/entities"
        }
    }
    
    private let apiKey: String
    private let region: String
    
    init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path)!
        apiKey = plist["textAnalyticsApiKey"] as! String
        region = plist["textAnalyticsRegion"] as! String
    }
    
    func keyphrases(of documents: [TextAnalyticsDocument], handler: (([Result.KeyPhrase]) -> Void)?) {
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": apiKey,
            "Content-Type": "application/json"
        ]
        //let body = Document.jsonString(from: documents)
        
        let parameters = ["documents" : documents.map({ $0.dictionary })]
        
        Alamofire.request(Constants.Endpoint.keyPhrases,
                          method: .post, parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            guard let json = response.result.value as? [String: Any] else { return }
            
                            //print("JSON: \(json)")
            
                            guard let documents = json["documents"] as? [Dictionary<String, Any>] else { return }
            
                            var keyphrases = [Result.KeyPhrase]()
                            for doc in documents {
                                let id = doc["id"] as! String
                                let kk = doc["keyPhrases"] as! [String]
                                let filtered =  kk.filter { !TextAnalytics.filteredKeyPhrases.contains($0.lowercased()) }
                                keyphrases += filtered.map({ Result.KeyPhrase(documentId: id, content: $0) })
                            }
                            //let keyPhrasesDocuments = documents.map({ TextAnalytics.Result.KeyPhrases(from: $0) })
                            //let errors = json["errors"] as? [String: Any]
            
                            if let completionHandler = handler {
                                completionHandler(keyphrases)
                            }
        }
    }
    
    func entities(of documents: [TextAnalyticsDocument], handler:(([Result.Entity]) -> Void)?) {
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": apiKey,
            "Content-Type": "application/json"
        ]
        let parameters = ["documents" : documents.map({ $0.dictionary })]
        
        Alamofire.request(Constants.Endpoint.entities,
                          method: .post, parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            guard let json = response.result.value as? [String: Any] else { return }
                            guard let documents = json["documents"] as? [Dictionary<String, Any>] else { return }
                            
                            var entities = [Result.Entity]()
                            for doc in documents {
                                let id = doc["id"] as! String
                                let kk = doc["entities"] as! [[String : Any]]
                                entities += kk.map({ Result.Entity.from(documentId: id, dictionary: $0) })
                            }
 
                            if let completionHandler = handler {
                                completionHandler(entities)
                            }
        }
    }
    
    
}
