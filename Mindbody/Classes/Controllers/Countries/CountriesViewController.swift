//
//  CountriesViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import RxCocoa

class CountriesViewController: BaseViewController {
    
    let viewModel = CountriesViewModel()
    var theCountries: BehaviorRelay<[Country]> = BehaviorRelay(value: [])

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
    
    override func setupAccessibility() {
        countriesTable?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountriesViewController.countriesTable
        refreshControl?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountriesViewController.refreshControl
    }
    
    override func setupObservers() {
        // Clears the countries array before setting it up as an observable.
        theCountries.accept([])
        // Sets up the countries array as an RxSwift observable.
        // Along with a completion block that executes whenever this object changes.
        theCountries.asObservable().subscribe(onNext: { [weak self] items in
            self?.countriesTable?.reloadData()
            self?.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
}

// MARK: - CountriesViewModelDelegate

extension CountriesViewController: CountriesViewModelDelegate {

    func didLoad(with countries: [Country]) {
        countriesTable?.stopLoading()
        theCountries.accept(countries)
    }
    
    func didLoad(with error: RequestError?) {
        countriesTable?.stopLoading()
        let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel.fetchCountries()
        }
        AlertHelper.showAlert(with: error?.title ?? "N/A", message: error?.message ?? "N/A", at: self, actions: [retry])
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
        guard theCountries.value.count > 0 else { return 0 }
        return theCountries.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < theCountries.value.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        let country = theCountries.value[indexPath.row]
        cell.configure(with: country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < theCountries.value.count else {
            let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
                self?.viewModel.fetchCountries()
            }
            AlertHelper.showAlert(with: "Error", message: "An error occured!", at: self, actions: [retry])
            return
        }
        let viewModel = CountryDetailsViewModel()
        viewModel.country = theCountries.value[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "CountryDetailsViewController") as? CountryDetailsViewController {
            viewController.viewModel = viewModel
            present(viewController, animated: true, completion: nil)
        }
    }
}
