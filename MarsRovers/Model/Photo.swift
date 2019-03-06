//
//  Photo.swift
//  MarsRovers
//
//  Created by Henrique Velloso on 06/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation

struct Photo : Decodable{
    var id: Int
    var camera: Camera
    var imageSource: String
    var earthDate: String
    var rover: Rovers
}

