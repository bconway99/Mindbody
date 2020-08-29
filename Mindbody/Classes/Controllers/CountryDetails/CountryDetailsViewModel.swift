//
//  CountryDetailsViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation
import ObjectMapper
import Handy

protocol CountryDetailsViewModelDelegate: class {
    
    /// Called when the network call has returned successfully with the `province` objects.
    func didLoad(with countries: [Province])
    
    /// Called when the network call has failed.
    func didLoad(with error: RequestError?)
}

class CountryDetailsViewModel: BaseViewModel {
    
    weak var delegate: CountryDetailsViewModelDelegate?
    var country: Country?
    
    override func setup() {
        super.setup()
    }
    
    /// Fetches the list of Mindbody provinces from the API endpoint.
    func fetchProvinces() {
    }
}
