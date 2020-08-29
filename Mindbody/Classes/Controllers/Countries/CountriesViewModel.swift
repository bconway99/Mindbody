//
//  CountriesViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

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
    }
}
