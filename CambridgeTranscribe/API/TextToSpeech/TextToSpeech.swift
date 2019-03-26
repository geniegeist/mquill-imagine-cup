//
//  TextToSpeech.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class TextToSpeech {

    struct Constants {
        struct Endpoint {
            static let token = "https://westeurope.api.cognitive.microsoft.com/sts/v1.0/issueToken"
            static let textToSpeech = "https://westeurope.tts.speech.microsoft.com/cognitiveservices/v1"
        }
    }
    
    private let apiKey: String
    private var jwtToken: String?
    
    init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path)!
        apiKey = plist["textToSpeechApiKey"] as! String
    }
    
    func getToken(_ completionBlock:(() -> Void)? = nil) {
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": apiKey,
            "Content-type": "application/x-www-form-urlencoded",
            "Content-Length": "0"
        ]
        
        Alamofire.request(Constants.Endpoint.token, method: .post, headers: headers).responseString { (response) in
            print(response)
            self.jwtToken = response.result.value
            
            if let handler = completionBlock {
                handler()
            }
        }
    }
    
    func speechFrom(text: String, handler:((Data?) -> Void)?) {
        if (jwtToken == nil || true) {
            getToken() {
                self.startSpeechRequest(text: text, handler: handler)
            }
        } else {
            self.startSpeechRequest(text: text, handler: handler)
        }
    }
    
    func startSpeechRequest(text: String, handler:((Data?) -> Void)?) {
        guard let jwtToken = self.jwtToken else { return }
        
        let body = "<speak version='1.0' xml:lang='en-US'><voice xml:lang='en-GB' xml:gender='Female' name='Microsoft Server Speech Text to Speech Voice (en-US, JessaNeural)'>\(text)</voice></speak>"
        
        var request = URLRequest(url: URL(string: Constants.Endpoint.textToSpeech)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/ssml+xml", forHTTPHeaderField: "Content-Type")
        request.setValue("riff-24khz-16bit-mono-pcm", forHTTPHeaderField: "X-Microsoft-OutputFormat")
        
        request.httpBody = body.data(using: .utf8)
        
        Alamofire.request(request).responseData { audioData in
            let data = audioData.result.value
            print(data ?? "No data")
            
            if let handler = handler {
                handler(data)
            }
        }
    }
}
