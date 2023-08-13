//
//  API.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import Foundation

struct APIResult: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let previewUrl: String
}

class API {
    
    static let basePath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
    
    static let configuration: URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
        
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 45.0
        config .httpMaximumConnectionsPerHost = 5
        
        return config
    }()
    
    static let session = URLSession(configuration: configuration)
    
    static func loadTrailers(title: String, onComplete: @escaping (APIResult?) -> Void) {
        
        guard let encodedTitle = (title).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              
        let url = URL(string: basePath+encodedTitle) else {
            onComplete(nil)
            return
        }
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                onComplete(nil)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        onComplete(nil)
                        return
                    }
                    
                    do {
                        let apiResult = try JSONDecoder().decode(APIResult.self, from: data)
                        onComplete(apiResult)
                    } catch {
                        onComplete(nil)
                    }
                } else {
                    onComplete(nil)
                }
            }
        }
        
        task.resume()
    }
}
