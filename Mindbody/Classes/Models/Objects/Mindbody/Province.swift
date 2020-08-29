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
