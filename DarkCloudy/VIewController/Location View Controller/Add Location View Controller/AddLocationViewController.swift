import UIKit

protocol AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

class AddLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewModel: AddLocationViewViewModel!
    
    // MARK: -
    
    var delegate: AddLocationViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel = AddLocationViewViewModel()
        viewModel.locationDidChange = { [unowned self] (locations) in
            self.tableView.reloadData()
        }
        viewModel.queryingDidChange = { [unowned self] (querying) in
            if querying {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        }
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
    
}

private extension AddLocationViewController {
    func setupNavigationBar() {
        title = "Add Location"
    }
    
}

extension AddLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLocations
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationViewCell.reuseIdetifier(), for: indexPath) as? LocationViewCell else { fatalError("Unexpected Table View Cell") }
        
        if let viewModel = viewModel.viewModelForLocation(index: indexPath.row) {
            // Configure Table View Cell
            cell.configureCell(viewModel: viewModel)
        }
        
        return cell
    }
}

extension AddLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let location = viewModel.location(index: indexPath.row) else { return }
        
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
        
        viewModel.query = searchBar.text ?? ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        
        // Forward Geocode Address String
        viewModel.query = searchBar.text ?? ""
    }
}
