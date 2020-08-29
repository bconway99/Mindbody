//
//  CountryCell.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import SDWebImage

class CountryCell: UITableViewCell {
        
    static let className: String = "CountryCell"
    static let identifier: String = "CountryCell"
    static let height: CGFloat = 40.0
}

// MARK: - Configuration

extension CountryCell {
    
    func configure(with country: Country? = nil) {
        guard let country = country, let code = country.code else {
            return
        }
        let flagEndpoint = String(format: Constants.CountryFlags.Endpoints.flag, code)
        let flagURL = URL(string: String(format: Constants.CountryFlags.domain, flagEndpoint))
        // As part of the SDWebImage framework I could add a placeholder image until the target image is loaded.
        imageView?.sd_setImage(with: flagURL, completed: nil)
        textLabel?.text = country.name ?? "N/A"
        selectionStyle = .none
    }
}
