//
//  Constants.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

class Constants: NSObject {
    
    // MARK: - AccessibilityIdentifiers

    class MindbodyAPI {

        static let domain: String = "connect.mindbodyonline.com%@"
        class Endpoints {
            static let countries: String = "/rest/worldregions/country"
        }
    }

    // MARK: - AccessibilityIdentifiers

    class AccessibilityIdentifiers {
        
        class CountriesViewController {
            static let countriesTable: String = "CountriesTable"
            static let refreshControl: String = "RefreshControl"
        }
    }
}
