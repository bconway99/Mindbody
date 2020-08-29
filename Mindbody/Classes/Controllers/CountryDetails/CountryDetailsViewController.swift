//
//  CountryDetailsViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import RxCocoa

class CountryDetailsViewController: BaseViewController {
    
    var viewModel: CountryDetailsViewModel?
    var theProvinces: BehaviorRelay<[Province]> = BehaviorRelay(value: [])

    var refreshControl: UIRefreshControl?
    @IBOutlet weak var provincesTable: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        viewModel?.delegate = self
        viewModel?.setup()
        viewModel?.fetchProvinces()
        navigationBar?.title = viewModel?.country?.name ?? "N/A"
    }
}

// MARK: - Override

extension CountryDetailsViewController {
    
    override func setupAccessibility() {
        provincesTable?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountryDetailsViewController.provincesTable
        refreshControl?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountryDetailsViewController.refreshControl
    }
    
    override func setupObservers() {
        // Clears the provinces array before setting it up as an observable.
        theProvinces.accept([])
        // Sets up the provinces array as an RxSwift observable.
        // Along with a completion block that executes whenever this object changes.
        theProvinces.asObservable().subscribe(onNext: { [weak self] items in
            self?.provincesTable?.reloadData()
            self?.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
}

// MARK: - CountryDetailsViewModelDelegate

extension CountryDetailsViewController: CountryDetailsViewModelDelegate {

    func didLoad(with provinces: [Province]) {
        theProvinces.accept(provinces)
    }
    
    func didLoad(with error: RequestError?) {
        // TODO: Show alert error.
    }
}

// MARK: - UI

extension CountryDetailsViewController {
    
    func setupTable() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        if let refresh = refreshControl { provincesTable?.addSubview(refresh) }
        provincesTable?.separatorStyle = .singleLine
        provincesTable?.register(UINib(nibName: ProvinceCell.className, bundle: nil), forCellReuseIdentifier: ProvinceCell.identifier)
    }
}

// MARK: - Actions

extension CountryDetailsViewController {
    
    @objc func refreshPulled() {
        viewModel?.fetchProvinces()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProvinceCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard theProvinces.value.count > 0 else { return 0 }
        return theProvinces.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < theProvinces.value.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: ProvinceCell.identifier, for: indexPath) as? ProvinceCell else {
            return UITableViewCell()
        }
        let province = theProvinces.value[indexPath.row]
        cell.configure(with: province)
        return cell
    }
}
