import XCTest
@testable import DarkCloudy

class WeatherDayViewViewModelTests: XCTestCase {
    
    // MARK: - Set Up & Tear Down
    
    var viewModel: WeatherDayViewViewModel!
    
    // MARK: - Set Up & Tear Down
    
    override func setUp() {
        super.setUp()
        
        // Load Stub
        let data = loadStubFromBundle(name: "darkSky", extension: "json")
        let weatherData: WeatherData = try! JSONDecode.decode(data: data)
        
        // Initialize View Model
        viewModel = WeatherDayViewViewModel(weatherDayData: weatherData.dailyData[5])
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Reset User Defaults
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.unitsNotation)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.temperatureNotation)
    }
    
    // MARK: - Tests for Day
    
    func testDay() {
        XCTAssertEqual(viewModel.day, "Thursday")
    }
    
     // MARK: - Tests for Date
    
    func testDate() {
        XCTAssertEqual(viewModel.date, "January 4")
    }
    
    // MARK: - Tests for Temperature
    
    func testTemperature_Celsius() {
        let temperatureNotations: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotations.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        XCTAssertEqual(viewModel.temperature, "54 °F / 62 °F")
    }
    
    func testTemperature_Fahrenheit() {
        let temperatureNotations: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotations.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        XCTAssertEqual(viewModel.temperature, "12 °C / 17 °C")
    }
    
    // MARK: - Tests for Wind Speed
    
    func testWindSpeed_Imperial() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        XCTAssertEqual(viewModel.windSpeed, "5 MPH")
    }
    
    func testWindSpeed_Metric() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        XCTAssertEqual(viewModel.windSpeed, "9 KPH")
    }
    
    // MARK: - Tests for Image
    
    func testImage() {
        let viewModelImage = viewModel.image
        let imageDataViewModel = UIImagePNGRepresentation(viewModelImage!)!
        let imageDataReference = UIImagePNGRepresentation(#imageLiteral(resourceName: "cloudy"))!
        
        XCTAssertNotNil(viewModelImage)
        XCTAssertEqual(viewModelImage!.size.width, 236.0)
        XCTAssertEqual(viewModelImage!.size.height, 172.0)
        XCTAssertEqual(imageDataViewModel, imageDataReference)
    }
}
