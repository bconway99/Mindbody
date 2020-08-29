//
//  ProvinceCell.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import SDWebImage

class ProvinceCell: UITableViewCell {
        
    static let className: String = "ProvinceCell"
    static let identifier: String = "ProvinceCell"
    static let height: CGFloat = 40.0
}

// MARK: - Configuration

extension ProvinceCell {
    
    func configure(with province: Province? = nil) {
        guard let province = province else {
            return
        }
        textLabel?.text = province.name ?? "N/A"
        selectionStyle = .none
    }
}
