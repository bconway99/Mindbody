//
//  CountryDetailsViewController.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa

class CountryDetailsViewController: BaseViewController {
    
    var viewModel: CountryDetailsViewModel?
    var theProvinces: BehaviorRelay<[Province]> = BehaviorRelay(value: [])

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
        provincesTable?.stopLoading()
        mapView?.stopLoading()
        guard provinces.count > 0 else {
            let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
                self?.viewModel?.fetchProvinces()
            }
            AlertHelper.showAlert(with: "No Provinces", message: "No provinces were returned!", at: self, actions: [retry])
            return
        }
        theProvinces.accept(provinces)
    }
    
    func didLoad(with error: RequestError?) {
        provincesTable?.stopLoading()
        mapView?.stopLoading()
        let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel?.fetchProvinces()
        }
        AlertHelper.showAlert(with: error?.title ?? "N/A", message: error?.message ?? "N/A", at: self, actions: [retry])
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < theProvinces.value.count else {
            let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] (action: UIAlertAction) in
                self?.viewModel?.fetchProvinces()
            }
            AlertHelper.showAlert(with: "Error", message: "An error occured!", at: self, actions: [retry])
            return
        }
        let province = theProvinces.value[indexPath.row]
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
                // If we cannot find the correct location then reset the map.
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView?.addAnnotation(annotation)
        
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        mapView?.setCenter(coordinate, animated: true)
    }
}
