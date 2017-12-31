import XCTest
@testable import DarkCloudy

class SettingsViewUnitsViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.unitsNotation)
    }
    
    func testText_Imperial() {
        let viewModel = SettingsViewUnitsViewModel(unitsNotation: .imperial)
        
        XCTAssertEqual(viewModel.text, "Imperial")
    }
    
    func testText_Metric() {
        let viewModel = SettingsViewUnitsViewModel(unitsNotation: .metric)
        
        XCTAssertEqual(viewModel.text, "Metric")
    }
    
    func testAccessoryType_Imperial_Imperial() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        let viewModel = SettingsViewUnitsViewModel(unitsNotation: .imperial)
        
        XCTAssertEqual(viewModel.accessoryType, .checkmark)
    }
    
    func testAccessoryType_Imperial_Metric() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        let viewModel = SettingsViewUnitsViewModel(unitsNotation: .metric)
        
        XCTAssertEqual(viewModel.accessoryType, .none)
    }
    
    func testAccessoryType_Metric_Imperial() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        let viewModel = SettingsViewUnitsViewModel(unitsNotation: .imperial)
        
        XCTAssertEqual(viewModel.accessoryType, .none)
    }
    
    func testAccessoryType_Metric_Metric() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
        
        let viewModel = SettingsViewUnitsViewModel(unitsNotation: .metric)
        
        XCTAssertEqual(viewModel.accessoryType, .checkmark)
    }
    
}

