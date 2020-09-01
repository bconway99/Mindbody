//
//  CountryDetailsViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation
import ObjectMapper
import RxCocoa
import Handy

protocol CountryDetailsViewModelDelegate: BaseViewModelDelegate {
    
    /// Called when the network call has failed.
    func didLoadError(with title: String?, message: String?)
}

class CountryDetailsViewModel: BaseViewModel {
    
    weak var delegate: CountryDetailsViewModelDelegate?
    var provinces: BehaviorRelay<[Province]> = BehaviorRelay(value: [])
    var country: Country?
    
    override func setup() {
        super.setup()
    }
    
    /// Fetches the list of Mindbody provinces from the API endpoint.
    func fetchProvinces() {
        guard let countryID = country?.id else {
            delegate?.didLoadError(with: "Error", message: "Invalid country object!")
            return
        }
                
        // HandyNetworking is a class that I wrote within my personal Swift Package called Handy.
        // I created it with the purpose of sharing utility methods across my projects.
        let url = HandyNetworking.createPath(
            domain: Constants.MindbodyAPI.domain,
            endpoint: String(format: Constants.MindbodyAPI.Endpoints.provinces, "\(countryID)"),
            isSecure: true
        )
        
        let request = Request(type: .get, url: url)
        RequestHelper.addRequest(request: request) { [weak self] (success: Bool, json: Any?, error: Error?) in
            switch success {
                
            case true:
                if let json = json, let provinces = Mapper<Province>().mapArray(JSONObject: json) {
                    self?.provinces.accept(provinces)
                    self?.delegate?.didLoadData()
                } else {
                    self?.delegate?.didLoadError(with: "Error", message: "Failed request!")
                }
                break
                
            case false:
                self?.delegate?.didLoadError(with: "Error", message: "Failed request!")
                break
            }
        }
    }
}
