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
    
    var week: [WeatherDayData]? {
        didSet {
            updateView()
        }
    }
    
    // MARK: -
    
    private lazy var dayFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter
    }()
    
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
            
            guard let week = self.week else {
                self.messageLabel.isHidden = false
                self.messageLabel.text = "Cloudy was unable to fetch weather data."
                return
            }
            
            self.updateWeatherDataContainer(weatherDayData: week)
        }
    }
    
    func updateWeatherDataContainer(weatherDayData: [WeatherDayData]) {
        weatherDataContainer.isHidden = false
        
        tableView.reloadData()
    }
}

extension WeekViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return week == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let week = week else { return 0 }
        
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekViewCell.reuseIdetifier(), for: indexPath) as? WeekViewCell else {
            return UITableViewCell()
        }
        guard let week = week else {
            
            return UITableViewCell()
            
        }
        
        let weatherData = week[indexPath.row]
        
        // Configure Cell
        cell.dayLabel.text = dayFormatter.string(from: weatherData.time)
        cell.dateLabel.text = dateFormatter.string(from: weatherData.time)
        
        
        var temperatureMin = weatherData.temperatureMin
        var temperatureMax = weatherData.temperatureMax
        if UserDefaults.getTemperatureNotation() == .celsius {
            temperatureMin = temperatureMin.toCelcius()
            temperatureMax = temperatureMax.toCelcius()
        }
        let min = String(format: "%.0f°", temperatureMin)
        let max = String(format: "%.0f°", temperatureMax)
        cell.temperatureLabel.text = "\(min) / \(max)"
        
        
        let windSpeed = weatherData.windSpeed
        switch UserDefaults.getUnitsNotation() {
        case .imperial:
            cell.windSpeedLabel.text = String(format: "%.f MPH", windSpeed)
        case .metric:
            cell.windSpeedLabel.text = String(format: "%.f KPH", windSpeed.toKPH())
        }
        
        
        cell.iconImageView.image = imageForIcon(withName: weatherData.icon)
        
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
