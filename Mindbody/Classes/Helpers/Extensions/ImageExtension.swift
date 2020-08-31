//
//  ImageExtension.swift
//  Mindbody
//
//  Created by Ben Conway on 8/31/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Initialize the image with a URL.
    /// - Parameter url: The location of the data that we want to convert.
    convenience init?(with url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
