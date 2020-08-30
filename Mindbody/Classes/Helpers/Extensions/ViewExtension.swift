//
//  ViewExtension.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit

extension UIView {
    
    static let loadingViewTag = 10000
    
    /// Show the default spinner within the current view object.
    /// - Parameters:
    ///   - color: The color of the loading spinner.
    ///   - scale: The size of the loading spinner.
    func showLoading(color: UIColor? = nil, scale: CGFloat? = 1.0) {
        var loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: .medium)
        }
        
        let size = CGAffineTransform(scaleX: scale ?? 1.0, y: scale ?? 1.0)
        loading?.transform = size
        
        if let color = color {
            loading?.color = color
        }
        
        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading?.startAnimating()
        loading?.hidesWhenStopped = true
        loading?.tag = UIView.loadingViewTag
        
        if let loading = loading {
            addSubview(loading)
        }
        loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    /// If there is an existing loading spinner with the specified tag.
    /// Then stop its loading remove it from the superview.
    func stopLoading() {
        guard let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView else {
            return
        }
        loading.stopAnimating()
        loading.removeFromSuperview()
    }
}
