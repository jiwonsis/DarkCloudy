import UIKit

protocol DayViewControllerDelegate {
    func controllerDidTapSettingsButton(controller: DayViewController)
    func controllerDidTapLocationButton(controller: DayViewController)
}

class DayViewController: WeatherViewController {
    
    // MARK: - Properties
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
     // MARK: -
    
    var delegate: DayViewControllerDelegate?
    
    // MARK: -
    
    var viewModel: DayViewViewModel? {
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
            
            guard let viewModel = self.viewModel else {
                self.messageLabel.isHidden = false
                self.messageLabel.text = "Cloudy was unable to fetch weather data."
                return
            }
            self.updateWeatherDataContainer(viewModel: viewModel)
        }
        
    }
    
    func updateWeatherDataContainer(viewModel: DayViewViewModel) {
        weatherDataContainer.isHidden = false
        
        dateLabel.text = viewModel.date
        timeLabel.text = viewModel.time
        descriptionLabel.text = viewModel.summery
        temperatureLabel.text = viewModel.temperature
        windSpeedLabel.text = viewModel.windSpeed
        iconImageView.image = viewModel.image
    }
}
