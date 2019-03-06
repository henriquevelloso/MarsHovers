//
//  NetworkManager.swift
//  MarsRovers
//
//  Created by Henrique Velloso on 06/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let configurations = ConfigurationManager.getConfig()
    private init() {}
    
    
    func fetchPhotos(roverName:String, earthDate:String, completionHandler: @escaping ([Photo]) -> Void ) {
        
        if let config = self.configurations {
            var urlString = config.apiUrl.apiHost + config.apiUrl.apiPath + config.apiUrl.apiParameters + config.apiUrl.apiKey
            urlString = self.replaceKey(urlString, key: ParameterName.roverName.rawValue, value: roverName)!
            urlString = self.replaceKey(urlString, key: ParameterName.earthDate.rawValue, value: earthDate)!
            
            let url = URL(string: urlString)!
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let arrayPosts = [Photo]()
                DispatchQueue.main.async {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedPosts = try decoder.decode([Photo].self, from: data)
                            completionHandler(decodedPosts)
                        } catch {
                            completionHandler(arrayPosts)
                        }
                    }
                }
            }

            dataTask.resume()
        }
    }
    
    private func replaceKey(_ source: String, key: String, value: String) -> String? {
        if source.range(of: "{\(key)}") != nil {
            return source.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
}
