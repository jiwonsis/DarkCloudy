import UIKit
import RxCocoa
import RxSwift

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
    
    private let disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel = AddLocationViewViewModel(query: searchBar.rx.text.orEmpty.asDriver())
        
        viewModel.locations
            .drive(onNext: { [unowned self](_) in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.querying
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
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
}
