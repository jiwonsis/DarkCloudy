import UIKit
import CoreLocation

class RootViewViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var dayView: UIView!
    var dayViewController: DayViewController!
    
    @IBOutlet weak var weekView: UIView!
    var weekViewController: WeekViewController!
    
    // MARK: - Private Properties
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchWeatherData()
        }
    }
    
    private lazy var dataManager = {
       return DataManger(baseURL: API.AuthenticatedBaseURL)
    }()
    
    private lazy var locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()
        
        // Configure Location Manager
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0
        
        return locationManager
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotificationHandling()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension RootViewViewController {
    
    func setupView() {
        subViewClassing()
    }
    
    func subViewClassing() {
        dayViewController = DayViewController()
        dayView.addSubview(dayViewController.view)
        resetLayout(targetView: dayView, addingView: dayViewController.view)
        
        weekViewController = WeekViewController()
        weekViewController.delegate = self
        weekView.addSubview(weekViewController.view)
        resetLayout(targetView: weekView, addingView: weekViewController.view)
    }
    
    func fetchWeatherData() {
        guard let location = currentLocation else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        dataManager.weatherDataForLocation(latitude: latitude, longitude: longitude) { (response, error) in
            if let error = error {
                print(error)
            }
            
            guard let response = response else { return }
            
            // Configure Day View Controller
            
            self.dayViewController.now = response
            
            // Configure Week View Controller
            
            self.weekViewController.week = response.dailyData
        }
    }
    
    func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func requestLocation() {
        // Configure Location Manager
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Request Current Location
            locationManager.requestLocation()
        } else {
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        requestLocation()
    }

}

extension RootViewViewController: CLLocationManagerDelegate {
    // MARK: - Authorization
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Request Location
            manager.requestLocation()
        } else {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: Default.Latitude, longitude: Default.Longitude)
        }
    }
    
    // MARK: - Location Updates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
             // Update Current Location
            currentLocation = location
            
            // Reset Delegate
            manager.delegate = nil
            
            // Stop Location Manager
            manager.stopUpdatingLocation()
        } else {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: Default.Latitude, longitude: Default.Longitude)
        }
    }
    
    // LocationManager Error
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        if currentLocation == nil {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: Default.Latitude, longitude: Default.Longitude)
        }
    }
}

extension RootViewViewController: WeekViewControllerDelegate {
    func controllerDidRefresh(controller: WeekViewController) {
        fetchWeatherData()
    }
    
    
}


