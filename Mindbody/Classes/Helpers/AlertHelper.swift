//
//  AlertHelper.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    
    /// Shows an alert on a specified screen with custom actions plus the default "Ok" action.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message body of the alert.
    ///   - viewController: The specified view controller on which to present the alert.
    ///   - actions: The user actions to add onto this alert.
    static func showAlert(with title: String, message: String, at viewController: UIViewController, actions: [(UIAlertAction)]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        actions?.forEach({ (action) in
            alert.addAction(action)
        })
        viewController.present(alert, animated: true, completion: nil)
    }
}
