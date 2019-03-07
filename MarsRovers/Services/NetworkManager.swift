//
//  NetworkManager.swift
//  MarsRovers
//
//  Created by Henrique Velloso on 06/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let configurations = ConfigurationManager.getConfig()
    private init() {}
    
    
    func fetchPhotos(roverName:String, earthDate:String, completionHandler: @escaping ([Photo]?, PhotosStoreError?) -> Void ) {
        
        if let config = self.configurations {
            var urlString = config.apiUrl.apiHost + config.apiUrl.apiPath + config.apiUrl.apiParameters + config.apiUrl.apiKey
            urlString = self.replaceKey(urlString, key: ParameterName.roverName.rawValue, value: roverName)!
            urlString = self.replaceKey(urlString, key: ParameterName.earthDate.rawValue, value: earthDate)!
            
            
            
            let request = URLRequest(url: URL(string: urlString)!)
            let session = URLSession.shared
            
          
                let task = session.dataTask(with: request) { (data, response, error) in
                    guard (error == nil) else {
                        completionHandler(nil, PhotosStoreError.CannotFetch("Task returned error \(error!)"))
                        return
                    }
                    
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                        completionHandler(nil, PhotosStoreError.CannotFetch("Your request returned a status code other than 2xx!"))
                        return
                    }
                    
                    guard let data = data else {
                        completionHandler(nil, PhotosStoreError.CannotFetch("No data was returned by the request!"))
                        return
                    }
                    
                    var parsedData: AnyObject? = nil
                    do {
                        parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                        if let parsedData = parsedData {
                            self.parseToPhotos(parsedData, completionHandlerForConvertData: completionHandler)
                        }
                        
                    } catch {
                        completionHandler(nil, PhotosStoreError.CannotFetch( "Could not parse the data as JSON: \(data)"))
                    }
                    
                }
                task.resume()
 
            
            
        }
    }
    
    private func parseToPhotos(_ parsedData: AnyObject, completionHandlerForConvertData: ([Photo]?, PhotosStoreError?) -> Void) {
        
        guard let photosData = parsedData["photos"] as? [[String:AnyObject]] else {
            completionHandlerForConvertData(nil, PhotosStoreError.CannotFetch( "Could not parse the data into photos."))
            return
        }
        print(parsedData as Any)
        
        var photos = [Photo]()
        for photo in photosData {
            guard let id = photo["id"] as? Int,
                let earthDate = photo["earth_date"] as? String,
                let imageSource = photo["img_src"] as? String else {
                    continue
            }
            
            
            
            
            //let photo = Photo(id: id, earthDate: earthDate, imageSource: imageSource, imageData: nil)
            var camera = Camera.init(id: "", name: "", fullName: "")
            var photoModel = Photo.init(id: id, camera: camera, imageSource: imageSource, earthDate: earthDate, rover: Rovers.Curiosity)
            
            print(photo as Any)
            photos.append(photoModel)
        }
        
        completionHandlerForConvertData(photos, nil)
        
    }
    
    private func replaceKey(_ source: String, key: String, value: String) -> String? {
        if source.range(of: "{\(key)}") != nil {
            return source.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
}




