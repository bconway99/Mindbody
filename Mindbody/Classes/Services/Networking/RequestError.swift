//
//  RequestError.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

class RequestError: Error {
    
    var title: String?
    var message: String?

    init(title: String?, message: String?) {
        if let title = title {
            self.title = title
        }
        if let message = message {
            self.message = message
        }
    }
}
