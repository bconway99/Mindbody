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
    
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var countriesTable: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        viewModel.delegate = self
        viewModel.setup()
        viewModel.fetchCountries()
    }
}

// MARK: - Override

extension CountriesViewController {
    
    /// This method is part of the superclass and does nothing unless overridden.
    /// It helps provide a structured yet flexible architecture as we can choose whether we want to implement or not.
    override func setupAccessibility() {
        super.setupAccessibility()
        // We can use accessibility identifiers to help improve the experience for impaired users.
        // These will help identify the UI for Apple’s VoiceOver to read over to the end user.
        countriesTable?.accessibilityLabel = Constants.AccessibilityLabels.CountriesViewController.countriesTable
        refreshControl?.accessibilityLabel = Constants.AccessibilityLabels.CountriesViewController.refreshControl
        countriesTable?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountriesViewController.countriesTable
        refreshControl?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountriesViewController.refreshControl
    }
    
    /// This method is part of the superclass and does nothing unless overridden.
    /// It helps provide a structured yet flexible architecture as we can choose whether we want to implement or not.
    override func setupObservers() {
        super.setupObservers()
        // Clears the countries array before setting it up as an observable.
        viewModel.countries.accept([])
        // Sets up the countries array as an RxSwift observable.
        // Along with a completion block that executes whenever this object changes.
        viewModel.countries.asObservable().subscribe(onNext: { [weak self] items in
            self?.countriesTable?.reloadData()
            self?.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
}

// MARK: - CountriesViewModelDelegate

extension CountriesViewController: CountriesViewModelDelegate {
    
    func didLoadData() {
        countriesTable?.stopLoading()
    }
    
    func didLoadError(with title: String?, message: String?) {
        countriesTable?.stopLoading()
        let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel.fetchCountries()
        }
        AlertHelper.showAlert(with: title ?? "N/A", message: message ?? "N/A", at: self, actions: [retry])
    }
}

// MARK: - UI

extension CountriesViewController {
    
    func setupTable() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        if let refresh = refreshControl { countriesTable?.addSubview(refresh) }
        countriesTable?.separatorStyle = .singleLine
        countriesTable?.register(UINib(nibName: CountryCell.className, bundle: nil), forCellReuseIdentifier: CountryCell.identifier)
        countriesTable?.showLoading(color: .gray, scale: 3.0)
    }
}

// MARK: - Actions

extension CountriesViewController {
    
    @objc func refreshPulled() {
        viewModel.fetchCountries()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CountryCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.countries.value.count > 0 else { return 0 }
        return viewModel.countries.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < viewModel.countries.value.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        let country = viewModel.countries.value[indexPath.row]
        cell.delegate = self
        cell.configure(with: country, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.countries.value.count else {
            let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
                self?.viewModel.fetchCountries()
            }
            AlertHelper.showAlert(with: "Error", message: "An error occured!", at: self, actions: [retry])
            return
        }
        let detailsViewModel = CountryDetailsViewModel()
        detailsViewModel.country = viewModel.countries.value[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "CountryDetailsViewController") as? CountryDetailsViewController {
            viewController.viewModel = detailsViewModel
            present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - CountryCellDelegate

extension CountriesViewController: CountryCellDelegate {
    
    func imageLoaded(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        countriesTable?.reloadRows(at: [indexPath], with: .none)
    }
}
