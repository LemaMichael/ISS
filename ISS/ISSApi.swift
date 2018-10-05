//
//  ISSApi.swift
//  ISS
//
//  Created by Michael Lema on 10/5/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation

struct Iss: Codable {
    let timestamp: Int
    let issPosition: IssPosition
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case issPosition = "iss_position"
        case message = "message"
    }
}

struct IssPosition: Codable {
    let longitude: String
    let latitude: String
    
    enum CodingKeys: String, CodingKey {
        case longitude = "longitude"
        case latitude = "latitude"
    }
}
