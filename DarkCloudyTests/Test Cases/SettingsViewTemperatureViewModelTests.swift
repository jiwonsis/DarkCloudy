import XCTest
@testable import DarkCloudy

class SettingsViewTemperatureViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.temperatureNotation)
    }
    
    func testText_Celsius() {
        let viewModel = SettingsViewTemperatureViewModel(temperatureNotation: .celsius)
        
        XCTAssertEqual(viewModel.text, "Celsius")
    }
    
    func testText_Fahrenheit() {
        let viewModel = SettingsViewTemperatureViewModel(temperatureNotation: .fahrenheit)
        
        XCTAssertEqual(viewModel.text, "Fahrenheit")
    }
    
    func testAccessoryType_Celsius_Celsius() {
        let temperatureNotation: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        let viewModel = SettingsViewTemperatureViewModel(temperatureNotation: .celsius)
        
        XCTAssertEqual(viewModel.accessoryType, .checkmark)
    }
    
    func testAccessoryType_Celsius_Fahrenheit() {
        let temperatureNotation: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        let viewModel = SettingsViewTemperatureViewModel(temperatureNotation: .fahrenheit)
        
        XCTAssertEqual(viewModel.accessoryType, .none)
    }
    
    func testAccessoryType_Fahrenheit_Celsius() {
        let temperatureNotation: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        let viewModel = SettingsViewTemperatureViewModel(temperatureNotation: .celsius)
        
        XCTAssertEqual(viewModel.accessoryType, .none)
    }
    
    func testAccessoryType_Fahrenheit_Fahrenheit() {
        let temperatureNotation: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
        
        let viewModel = SettingsViewTemperatureViewModel(temperatureNotation: .fahrenheit)
        
        XCTAssertEqual(viewModel.accessoryType, .checkmark)
    }
    
}


