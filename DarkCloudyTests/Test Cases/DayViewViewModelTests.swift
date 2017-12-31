import XCTest
@testable import DarkCloudy

class DayViewViewModelTests: XCTestCase {
    
    var viewModel: DayViewViewModel!
    
    override func setUp() {
        super.setUp()
        
        // Load Stub
        let data = loadStubFromBundle(name: "darkSky", extension: "json")
        let weatherData: WeatherData = try! JSONDecode.decode(data: data)
        
        // Initialize View Model
        viewModel = DayViewViewModel(weatherData: weatherData)
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Reset User Default
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.timeNotation)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.temperatureNotation)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.unitsNotation)
    }
    
    // MARK: - Tests for Date
    
    func testDate() {
        XCTAssertEqual(viewModel.date, "Sun, December 31")
    }
    
    // MARK: - Tests for Time
    
    func testTime_TwelveHour() {
        let timeNotation: TimeNotation = .twelveHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: UserDefaultsKeys.timeNotation)
        
        XCTAssertEqual(viewModel.time, "04:40 PM")
    }
    
    func testTime_TwentyFourHour() {
        let timeNotation: TimeNotation = .twentyFourHour
        UserDefaults.standard.set(timeNotation.rawValue, forKey: UserDefaultsKeys.timeNotation)
        
        XCTAssertEqual(viewModel.time, "16:40")
    }
    
    // MARK: - Tests for Summary
    
    func testSummary() {
        XCTAssertEqual(viewModel.summery, "Clear")
    }
    
    // MARK: - Tests for Temperature
    
    func testTemperature_Fahrenheit(){
        let temperature: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperature.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        XCTAssertEqual(viewModel.temperature, "43.1 °F")
    }
    
    func testTemperature_Celsius(){
        let temperature: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperature.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        XCTAssertEqual(viewModel.temperature, "6.2 °C")
    }
    
    // MARK: - Tests for Wind Speed
    
    func testWindSpeed_Imperial(){
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        XCTAssertEqual(viewModel.windSpeed, "0 MPH")
    }
    
    func testWindSpeed_Metric(){
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        XCTAssertEqual(viewModel.windSpeed, "1 KPH")
    }
    
    // MARK: - Tests for Image
    
    func testImage() {
        let viewModelImage = viewModel.image
        let imageDataViewModel = UIImagePNGRepresentation(viewModelImage!)!
        let imageDataReference = UIImagePNGRepresentation(#imageLiteral(resourceName: "clear-night"))!
        
        XCTAssertNotNil(viewModelImage)
        XCTAssertEqual(viewModelImage!.size.width, 236.0)
        XCTAssertEqual(viewModelImage!.size.height, 236.0)
        XCTAssertEqual(imageDataViewModel, imageDataReference)
    }
}
