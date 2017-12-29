import UIKit

class WeatherViewController: UIViewController {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var weatherDataContainer: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Public Interface
    
    func reloadData() {
        
    }

}

extension WeatherViewController {
   
    
    // MARK: - Helper Methods
    
    func imageForIcon(withName name: String) -> UIImage? {
        switch name {
        case "clear-day":
            return UIImage(named: "clear-day")
        case "clear-night":
            return UIImage(named: "clear-night")
        case "rain":
            return UIImage(named: "rain")
        case "snow":
            return UIImage(named: "snow")
        case "sleet":
            return UIImage(named: "sleet")
        case "wind", "cloudy", "partly-cloudy-day", "partly-cloudy-night":
            return UIImage(named: "cloudy")
        default:
            return UIImage(named: "clear-day")
        }
    }
}

private extension WeatherViewController {
    func setupView() {
        // Configure Message Label
        messageLabel.isHidden = true
        
        // Configure Weather Data Container
        weatherDataContainer.isHidden = true
        
        // Configure Activity Indicator View
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        
        weatherDataContainer.addSubview(containerView)
        resetLayout(targetView: weatherDataContainer, addingView: containerView)
    }
    
    private func updateView() {
        
    }
}
