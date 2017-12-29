import UIKit

protocol DayViewControllerDelegate {
    func controllerDidTapSettingsButton(controller: DayViewController)
    func controllerDidTapLocationButton(controller: DayViewController)
}

class DayViewController: WeatherViewController {
    
    // MARK: - Properties
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
     // MARK: -
    
    var delegate: DayViewControllerDelegate?
    
    // MARK: -
    
    var now: WeatherData? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }
    
    // MARK: - Public Interface
    
    override func reloadData() {
        updateView()
    }
    
    @IBAction func didTapSettingsButton() {
        delegate?.controllerDidTapSettingsButton(controller: self)
    }
    
    @IBAction func didTapLocationButton() {
        delegate?.controllerDidTapLocationButton(controller: self)
    }
}

extension DayViewController {
    func setupView() {
        weatherDataContainer.addSubview(containerView)
        resetLayout(targetView: weatherDataContainer, addingView: containerView)
    }
    
    
}

private extension DayViewController {
    func updateView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            
            guard let now = self.now else {
                self.messageLabel.isHidden = false
                self.messageLabel.text = "Cloudy was unable to fetch weather data."
                return
            }
            self.updateWeatherDataContainer(weatherData: now)
        }
        
    }
    
    func updateWeatherDataContainer(weatherData: WeatherData) {
        weatherDataContainer.isHidden = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: weatherData.time)
        
        cityLabel.text = weatherData.city
        
        descriptionLabel.text = weatherData.summary
        
        let temperature = weatherData.temperature
        switch UserDefaults.getTemperatureNotation() {
        case .celsius:
            temperatureLabel.text = String(format: "%.1f °C", temperature.toCelcius())
        case .fahrenheit:
            temperatureLabel.text = String(format: "%.1f °F", temperature)
        }
        
        
        let windSpeed = weatherData.windSpeed
        switch UserDefaults.getUnitsNotation() {
        case .imperial:
            windSpeedLabel.text = String(format: "%.f MPH", windSpeed)
        case .metric:
            windSpeedLabel.text = String(format: "%.f KPH", windSpeed.toKPH())
        }
        
        
        iconImageView.image = imageForIcon(withName: weatherData.icon)
    }
}
