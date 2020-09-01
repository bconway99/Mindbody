//
//  CountryDetailsViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import MapKit

class CountryDetailsViewController: BaseViewController {
    
    var viewModel: CountryDetailsViewModel?

    var refreshControl: UIRefreshControl?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var provincesTable: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupMapView()
        viewModel?.delegate = self
        viewModel?.setup()
        viewModel?.fetchProvinces()
        navigationBar?.title = viewModel?.country?.name?.capitalized ?? "N/A"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if
            let countryName = viewModel?.country?.name?.capitalized,
            let countryCode = viewModel?.country?.code {
            let address = String(format: "%@ %@", countryName, countryCode)
            getCoordinate(for: address)
        }
    }
}

// MARK: - Override

extension CountryDetailsViewController {
    
    /// This method is part of the superclass and does nothing unless overridden.
    /// It helps provide a structured yet flexible architecture as we can choose whether we want to implement or not.
    override func setupAccessibility() {
        super.setupAccessibility()
        // We can use accessibility identifiers to help improve the experience for impaired users.
        // These will help identify the UI for Apple’s VoiceOver to read over to the end user.
        provincesTable?.accessibilityLabel = Constants.AccessibilityLabels.CountryDetailsViewController.provincesTable
        refreshControl?.accessibilityLabel = Constants.AccessibilityLabels.CountryDetailsViewController.refreshControl
        provincesTable?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountryDetailsViewController.provincesTable
        refreshControl?.accessibilityIdentifier = Constants.AccessibilityIdentifiers.CountryDetailsViewController.refreshControl
    }
    
    /// This method is part of the superclass and does nothing unless overridden.
    /// It helps provide a structured yet flexible architecture as we can choose whether we want to implement or not.
    override func setupObservers() {
        super.setupObservers()
        // Clears the provinces array before setting it up as an observable.
        viewModel?.provinces.accept([])
        // Sets up the provinces array as an RxSwift observable.
        // Along with a completion block that executes whenever this object changes.
        viewModel?.provinces.asObservable().subscribe(onNext: { [weak self] items in
            self?.provincesTable?.reloadData()
            self?.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
}

// MARK: - CountryDetailsViewModelDelegate

extension CountryDetailsViewController: CountryDetailsViewModelDelegate {
    
    func didLoadData() {
        provincesTable?.stopLoading()
        mapView?.stopLoading()
        guard let provinces = viewModel?.provinces.value, provinces.count > 0 else {
            let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
                self?.viewModel?.fetchProvinces()
            }
            AlertHelper.showAlert(with: "No Provinces", message: "No provinces were returned!", at: self, actions: [retry])
            return
        }
    }
    
    func didLoadError(with title: String?, message: String?) {
        provincesTable?.stopLoading()
        mapView?.stopLoading()
        let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel?.fetchProvinces()
        }
        AlertHelper.showAlert(with: title ?? "N/A", message: message ?? "N/A", at: self, actions: [retry])
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
        provincesTable?.showLoading(color: .gray, scale: 3.0)
    }
    
    func setupMapView() {
        mapView?.isZoomEnabled = false
        mapView?.isScrollEnabled = false
        mapView?.isUserInteractionEnabled = false
        mapView?.showLoading(color: .gray, scale: 2.0)
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
        guard let provinces = viewModel?.provinces.value, provinces.count > 0 else { return 0 }
        return provinces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let provinces = viewModel?.provinces.value,
            indexPath.row < provinces.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: ProvinceCell.identifier, for: indexPath) as? ProvinceCell else {
            return UITableViewCell()
        }
        let province = provinces[indexPath.row]
        cell.configure(with: province)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let provinces = viewModel?.provinces.value,
            indexPath.row < provinces.count else {
            let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
                self?.viewModel?.fetchProvinces()
            }
            AlertHelper.showAlert(with: "Error", message: "An error occured!", at: self, actions: [retry])
            return
        }
        let province = provinces[indexPath.row]
        if
            let provinceName = province.name,
            let countryName = viewModel?.country?.name?.capitalized,
            let countryCode = viewModel?.country?.code {
            let address = String(format: "%@ %@ %@", provinceName, countryName, countryCode)
            getCoordinate(for: address)
        }
    }
}

// MARK: - Map

extension CountryDetailsViewController {
    
    func getCoordinate(for address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                // Sometimes the Geocoder cannot get a location based on the information provided.
                // Usually the returned error is `kCLErrorGeocodeFoundNoResult`.
                // So if we cannot find the correct location then reset the map.
                // This logic can be greatly improved to be more user friendly.
                self?.mapView?.reset()
                return
            }
            self?.configureMap(with: location)
        }
    }
    
    func configureMap(with location: CLLocation) {
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations)
        }
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView?.addAnnotation(annotation)
        mapView?.setCenter(coordinate, animated: true)
    }
}
