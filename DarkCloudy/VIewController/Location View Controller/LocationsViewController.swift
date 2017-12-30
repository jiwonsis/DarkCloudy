import UIKit
import CoreLocation

protocol LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation)
}

class LocationsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -
    
    var currentLocation: CLLocation?
    var favorites = UserDefaults.loadLocations()
    
    // MARK: -
    
    private var hasFavorites: Bool {
        return favorites.count > 0
    }
    
    // MARK: -
    
    var delegate: LocationsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

}

private extension LocationsViewController {
    func setupView() {
        setupTableView()
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: LocationViewCell.nibName, bundle: nil), forCellReuseIdentifier: LocationViewCell.reuseIdetifier())
    }
    
}

private extension LocationsViewController {
    func setupNavigationBar() {
        title = "Locations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addLocation() {
        let addLocationViewController = AddLocationViewController()
        addLocationViewController.delegate = self
        navigationController?.pushViewController(addLocationViewController, animated: true)
        addLocationViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(unwindToLocationsViewController))
    }
    
    @objc func unwindToLocationsViewController() {
        navigationController?.popViewController(animated: true)
    }
}

extension LocationsViewController: UITableViewDataSource {
    
    private enum Section: Int {
        case current
        case favorite
        
        // MARK: - Properties
        
        var title: String {
            switch self {
            case .current: return "Current Location"
            case .favorite: return "Favorite Location"
            }
        }
        
        var numberOfRows: Int {
            switch self {
            case .current: return 1
            case .favorite: return 0
            }
        }
        
        // MARK: -
        
        static var count: Int {
            return Section.favorite.rawValue + 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected Section") }
        
        switch section {
        case .current: return 1
        case .favorite: return max(favorites.count, 1)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected Section") }
        return section.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationViewCell.reuseIdetifier(), for: indexPath) as? LocationViewCell else { fatalError("Unexpected Table View Cell") }
        
        var viewModel: LocationRepresentable?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation {
                // Create View Model
                viewModel = LocationsViewLocationViewModel(location: currentLocation)
            } else {
                // Configure Table View Cell
                cell.mainLabel.text = "Current Location Unknown"
            }
        case .favorite:
            if favorites.count > 0 {
                // Fetch Favorite
                let favorite = favorites[indexPath.row]
                
                // Create View Model
                viewModel = LocationsViewLocationViewModel(location: favorite.location, locationAsString: favorite.name)
            } else {
                // Configure Table View Cell
                cell.mainLabel.text = "No Favorites Found"
            }
            
        }
        
        if let viewModel = viewModel {
            cell.configureCell(viewModel: viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Fetch Location
        let location = favorites[indexPath.row]
        
        // Update Favorites
        favorites.remove(at: indexPath.row)
        
        // Remove Location
        UserDefaults.removeLocation(location)
        
        // Update Table View
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        
        var location: CLLocation?
        
        switch section {
        case .current:
            guard let currentLocation = currentLocation else  { return }
            location = currentLocation
        case .favorite:
            if hasFavorites {
                location = favorites[indexPath.row].location
            }
            
        }
        
        guard let newLocation = location else { return }
        // Notify Delegate
        delegate?.controller(self, didSelectLocation: newLocation)
        
        // Dismiss Controller
        dismiss(animated: true)
    }
}

extension LocationsViewController: AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location) {
        // Update User Defaults
        UserDefaults.addLocation(location)
        
        // Update Locations
        favorites.append(location)
        
        // Update Table View
        tableView.reloadData()
    }
}
