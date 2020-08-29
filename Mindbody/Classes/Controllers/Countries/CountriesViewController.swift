//
//  CountriesViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit

class CountriesViewController: BaseViewController {
    
    let viewModel = CountriesViewModel()
    var theCountries: [Country]?
    
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var countriesTable: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countriesTable?.reloadData()
    }
}

// MARK: - Override

extension CountriesViewController {
    
    override func setupAccessibility() {
        countriesTable?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountriesViewController.countriesTable
        refreshControl?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountriesViewController.refreshControl
    }
    
    override func setupObservers() {
    }
}

// MARK: - CountriesViewModelDelegate

extension CountriesViewController: CountriesViewModelDelegate {

    func didLoad(with countries: [Country]) {
        theCountries = countries
    }
    
    func didLoad(with error: RequestError?) {
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
