//
//  Constants.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

class Constants: NSObject {
    
    // MARK: - MindbodyAPI

    class MindbodyAPI {

        static let domain: String = "connect.mindbodyonline.com%@"
        class Endpoints {
            static let countries: String = "/rest/worldregions/country"
        }
    }
    
    // MARK: - CountryFlags

    class CountryFlags {

        static let domain: String = "https://www.countryflags.io/%@"
        class Endpoints {
            static let flag: String = "/%@/shiny/64.png"
        }
    }
    
    class AccessibilityIdentifiers {
        
        class CountriesViewController {
            static let countriesTable: String = "CountriesViewController_CountriesTable"
            static let refreshControl: String = "CountriesViewController_RefreshControl"
        }
        
        class CountryDetailsViewController {
            static let provincesTable: String = "CountryDetailsViewController_ProvincesTable"
            static let refreshControl: String = "CountryDetailsViewController_RefreshControl"
        }
    }
}
