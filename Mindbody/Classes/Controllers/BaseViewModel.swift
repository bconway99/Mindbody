//
//  BaseViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/28/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

protocol BaseViewModelDelegate: class {
        
    /// Called when the network call has returned successfully with the `data` for a view model.
    func didLoadData()
}

class BaseViewModel: NSObject {
        
    // Add here any base logic setup.
    // Or protocols that we want all view models to comply to.
    // These can include sending analytics events, accessibility logic, etc.
}

// MARK: - Base Implementation

extension BaseViewModel {

    /// Setup the data model.
    @objc open func setup() {
        // Does nothing unless overridden in the subclass.
    }
}
