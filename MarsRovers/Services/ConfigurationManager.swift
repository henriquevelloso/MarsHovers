//
//  ConfigurationManager.swift
//  MarsRovers
//
//  Created by Henrique Velloso on 06/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation

class ConfigurationManager {
    
    static func getConfig() -> Configurations? {
        
        if  let path        = Bundle.main.path(forResource: "Configurations", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let config = try? PropertyListDecoder().decode(Configurations.self, from: xml)
        {
            return config
        }
        return nil
    }
    
}
