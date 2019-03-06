//
//  Configurations.swift
//  MarsRovers
//
//  Created by Henrique Velloso on 06/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation


struct Configurations: Codable {
    
    var apiUrl: ApiUrl

}


struct ApiUrl: Codable {
    
    var apiHost: String
    var apiPath: String
    var apiParameters: String
    var apiKey: String

}


