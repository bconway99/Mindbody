//
//  Request.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

struct Request {
    
    var type: RequestType?
    var url: String?
    var parameters: [String: Any]?
    var headers: [String: Any]?
}
