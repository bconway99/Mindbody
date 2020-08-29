//
//  BaseViewModel.swift
//  Mindbody
//
//  Created by Ben Conway on 8/28/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation

class BaseViewModel: NSObject {
        
    // Add here any base logic setup.
    // Or protocols that we want all view models to comply to.
}

// MARK: - Base Implementation

extension BaseViewModel {

    /// Setup the data model.
    @objc open func setup() {
        // Does nothing unless overridden in the subclass.
    }
}
