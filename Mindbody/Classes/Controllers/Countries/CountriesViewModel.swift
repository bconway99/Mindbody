//
//  CountriesViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation
import Handy

protocol CountriesViewModelDelegate: class {
    
    /// Called when the required data for the view controller has finished loading.
    func didLoad(data: Any)
}

class CountriesViewModel: BaseViewModel {
    
    weak var delegate: CountriesViewModelDelegate?
    
    override func setup() {
        super.setup()
    }
    
    /// Fetches the list of Mindbody countries from the API endpoint.
    func fetchCountries() {
        
        // HandyNetworking is a class that I wrote within my personal Swift Package called Handy.
        // I created it with the purpose of sharing utility methods across my projects.
        let url = HandyNetworking.createPath(
            domain: Constants.MindbodyAPI.domain,
            endpoint: Constants.MindbodyAPI.Endpoints.countries,
            isSecure: true
        )
        
        let request = Request(type: .get, url: url)
        RequestHelper.addRequest(request: request) { [weak self] (success: Bool, json: [String : Any]?, error: Error?) in
            switch success {
                
            case true:
                break
                
            case false:
                break
            }
        }
    }
}
