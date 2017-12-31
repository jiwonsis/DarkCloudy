import XCTest
@testable import DarkCloudy

class WeekViewViewModelTests: XCTestCase {
    
    var viewModel: WeekViewViewModel!
    
    override func setUp() {
        super.setUp()
        
        let data = loadStubFromBundle(name: "darkSky", extension: "json")
        let weatherData: WeatherData = try! JSONDecode.decode(data: data)
        
        viewModel = WeekViewViewModel(weatherData: weatherData.dailyData)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel.numberOfSections, 1)
    }
    
    func testNuberOfDays() {
        XCTAssertEqual(viewModel.numberOfDay, 8)
    }
    
    func testViewModelForIndex() {
        let weatherViewViewModel = viewModel.viewModel(for: 5)
        
        XCTAssertEqual(weatherViewViewModel.day, "Thursday")
        XCTAssertEqual(weatherViewViewModel.date, "January 4")
    }
    
}
