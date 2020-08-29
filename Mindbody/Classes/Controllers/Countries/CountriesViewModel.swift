//
//  CountriesViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation
import ObjectMapper
import Handy

protocol CountriesViewModelDelegate: class {
    
    /// Called when the network call has returned successfully with the `country` objects.
    func didLoad(with countries: [Country])
    
    /// Called when the network call has failed.
    func didLoad(with error: RequestError?)
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
        RequestHelper.addRequest(request: request) { [weak self] (success: Bool, json: Any?, error: Error?) in
            switch success {
                
            case true:
                if let json = json, let countries = Mapper<Country>().mapArray(JSONObject: json) {
                    self?.delegate?.didLoad(with: countries)
                } else {
                    self?.delegate?.didLoad(with: RequestError(title: "Error", message: "Failed request!"))
                }
                break
                
            case false:
                self?.delegate?.didLoad(with: RequestError(title: "Error", message: "Failed request!"))
                break
            }
        }
    }
}
