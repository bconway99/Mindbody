//
//  CountriesViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit

class CountriesViewController: BaseViewController {
    
    private let viewModel = CountriesViewModel()
    
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var countriesTable: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Override

extension CountriesViewController {
    
    override func setupAccessibility() {
        countriesTable?.accessibilityIdentifier = AccessibilityIdentifiers.CountriesViewController.countriesTable
        refreshControl?.accessibilityIdentifier = AccessibilityIdentifiers.CountriesViewController.refreshControl
    }
}

// MARK: - CountriesViewModelDelegate

extension CountriesViewController: CountriesViewModelDelegate {
    
    func didLoad(data: Any) {
    }
}
