//
//  AddLocationViewController.swift
//  DarkCloudy
//
//  Created by Scott moon on 30/12/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

class AddLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: -
    
    var delegate: AddLocationViewControllerDelegate?
    
    // MARK: -
    
    private var locations: [Location] = []
    
    // MARK: -
    
    private lazy var geocoder = CLGeocoder()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show Keyboard
        view.becomeFirstResponder()
    }
}

private extension AddLocationViewController {
    func setupView() {
        setupTableView()
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: LocationViewCell.nibName, bundle: nil), forCellReuseIdentifier: LocationViewCell.reuseIdetifier())
    }
    
    func geocode(addressString: String?) {
        
        guard let addressString = addressString else {
            // Clear Locations
            locations = []
            
            // Update Table View
            tableView.reloadData()
            
            return
        }
        
        // Geocode City
        geocoder.geocodeAddressString(addressString) { [weak self] (placeMarks, error) in
            DispatchQueue.main.async {
                // Process Forward Geocoding Response
                self?.processResponse(placeMarks: placeMarks, error: error)
            }
        }
    }
        
    // MARK: -
    func processResponse(placeMarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            return
        }
        
        guard let matches = placeMarks else { return }
        
        // Update Locations
        locations = matches.flatMap({ (match) -> Location? in
            guard let name = match.name else { return nil }
            guard let location = match.location else { return nil }
            return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        })
        
        // Update Table View
        tableView.reloadData()
        
    }
    
    
}

private extension AddLocationViewController {
    func setupNavigationBar() {
        title = "Add Location"
    }
    
}

extension AddLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationViewCell.reuseIdetifier(), for: indexPath) as? LocationViewCell else { fatalError("Unexpected Table View Cell") }
        
        // Fetch Location
        let location = locations[indexPath.row]
        
        // Create View Model
        let viewModel = LocationsViewLocationViewModel(location: location.location, locationAsString: location.name)
        
        // Configure Table View Cell
        cell.configureCell(viewModel: viewModel)
        
        return cell
    }
}

extension AddLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Location
        let location = locations[indexPath.row]
        
        // Notify Delegate
        delegate?.controller(self, didAddLocation: location)
        
        // Pop View Controller From Navigation Stack
        navigationController?.popViewController(animated: true)
    }
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        
        // Clear Locations
        locations = []
        
        // Update Table View
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        
        // Forward Geocode Address String
        geocode(addressString: searchBar.text)
    }
}
