//
//  Province.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation
import ObjectMapper

/// This object contains all of the data returned from the `provinces` endpoint.
class Province: Mappable {
        
    var map: Map?
    
    var id: Int?
    var name: String?
    var code: String?
    var countryCode: String?
    
    required init?(map: Map) {
        self.map = map
    }
    
    func mapping(map: Map) {
        id              <- map["ID"]
        name            <- map["Name"]
        code            <- map["Code"]
        countryCode     <- map["CountryCode"]
    }
}

extension Province {
    
    /// A JSON deserialization method without using third party libraries.
    /// I wanted to include this to show my understanding of deserialization logic outside of external frameworks.
    /// - Parameter json: The JSON to deserialize.
    func from(json: [String: Any]) {
        if let id = json["ID"] as? Int {
            self.id = id
        }
        if let name = json["Name"] as? String {
            self.name = name
        }
        if let code = json["Code"] as? String {
            self.code = code
        }
        if let countryCode = json["CountryCode"] as? String {
            self.countryCode = countryCode
        }
    }
}
