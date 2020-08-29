//
//  BaseViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/28/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var navigationBar: UINavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupObservers()
        setupAccessibility()
    }
}

// MARK: - Base Implementation

extension BaseViewController {

    /// Use this to setup the RxSwift `observable` & `observer` objects.
    /// An `observable` emits notifications of change.
    /// An `observer` subscribes to an observable and gets notified when that observable has changed.
    /// This method does nothing unless overridden in the subclass.
    @objc open func setupObservers() {
        // Does nothing unless overridden in the subclass.
    }
    
    /// Use this to setup the accessibility identifiers for each UI element.
    /// This helps both UI testing and accessibility for impaired users.
    /// This method does nothing unless overridden in the subclass.
    @objc open func setupAccessibility() {
        // Does nothing unless overridden in the subclass.
    }
}

// MARK: - Present

extension BaseViewController {
    
    /// iOS 13 introduced new card scene presentation logic for view controllers.
    /// This stacks the presented view controllers up like cards, leaving a gap at the top.
    /// So you can always see the previous one behind it and vastly changing the UI.
    /// Override the `present` method to force the `fullScreen` presentation style.
    /// All view controllers will need to be a subclass from `BaseViewController` for this to work.
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
       viewControllerToPresent.modalPresentationStyle = .fullScreen
       super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - Actions

extension BaseViewController {
    
    @IBAction open func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
