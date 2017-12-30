import UIKit

protocol WeekViewControllerDelegate {
    func controllerDidRefresh(controller: WeekViewController)
}

class WeekViewController: WeatherViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -
    
    var delegate: WeekViewControllerDelegate?
    
    // MARK: -
    
    var viewModel: WeekViewViewModel? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Public Methods
    override func reloadData() {
        updateView()
    }
    
}

extension WeekViewController {
    func setupView() {
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: WeekViewCell.nibName, bundle: nil), forCellReuseIdentifier: WeekViewCell.reuseIdetifier())
        tableView.separatorInset = UIEdgeInsets.zero
        setupRefreshController()
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
            
            guard let _ = self.viewModel else {
                self.messageLabel.isHidden = false
                self.messageLabel.text = "Cloudy was unable to fetch weather data."
                return
            }
            
            self.updateWeatherDataContainer()
        }
    }
    
    func updateWeatherDataContainer() {
        weatherDataContainer.isHidden = false
        
        tableView.reloadData()
    }
}

extension WeekViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfDay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekViewCell.reuseIdetifier(), for: indexPath) as? WeekViewCell else {
            return UITableViewCell()
        }
        guard let viewModel = viewModel?.viewModel(for: indexPath.row) else {
            
            return UITableViewCell()
            
        }
        
        // Configure Cell
        cell.configure(viewModel: viewModel)
        
        return cell
    }
}

private extension WeekViewController {
    func setupRefreshController() {
        // Initialize Refresh Control
        let refreshControl = UIRefreshControl()
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func didRefresh() {
        delegate?.controllerDidRefresh(controller: self)
    }
}
