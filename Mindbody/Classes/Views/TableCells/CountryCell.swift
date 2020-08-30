//
//  CountryCell.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import SDWebImage

protocol CountryCellDelegate: class {
    
    /// Called when the image has finished loading from the URL.
    /// - Parameter row: The index of the cell to be reloaded.
    func imageLoaded(at row: Int)
}

class CountryCell: UITableViewCell {
    
    static let className: String = "CountryCell"
    static let identifier: String = "CountryCell"
    static let height: CGFloat = 40.0
    
    var delegate: CountryCellDelegate?
}

// MARK: - Configuration

extension CountryCell {
    
    func configure(with country: Country? = nil, row: Int) {
        guard let country = country, let code = country.code else {
            return
        }
        let flagEndpoint = String(format: Constants.CountryFlags.Endpoints.flag, code)
        let flagURL = URL(string: String(format: Constants.CountryFlags.domain, flagEndpoint))
        // As part of the SDWebImage framework I could add a placeholder image until the target image is loaded.
        // In a production project I would leverage improved thread management here.
        // Images should be loaded on a background thread and then the UI updated on the main thread.
        imageView?.sd_setImage(
            with: flagURL,
            completed: { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
                self.delegate?.imageLoaded(at: row)
        })
        textLabel?.text = country.name?.capitalized ?? "N/A"
        selectionStyle = .none
    }
}
