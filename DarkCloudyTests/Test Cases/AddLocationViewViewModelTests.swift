import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import DarkCloudy

class AddLocationViewViewModelTests: XCTestCase {
    
    private class MockLocationService: LocationService {
        
        func geocode(addressString: String?, completionHandler: @escaping LocationService.LocationServiceCompletionHandler) {
            if let addressString = addressString, !addressString.isEmpty {
                // Create Location
                let location = Location(name: "Brussels", latitude: 50.8503, longitude: 4.3517)
                
                // Invoke Completion Handler
                completionHandler([location], nil)
            } else {
                // Invoce Completion Handler
                completionHandler([], nil)
            }
            
        }
    }
    
    var viewModel: AddLocationViewViewModel!
    
    var scheduler: SchedulerType!
    
    var query: BehaviorRelay<String>!
    
    override func setUp() {
        super.setUp()
        
        query = BehaviorRelay<String>(value: "")
        
        let locationService = MockLocationService()
        
        viewModel = AddLocationViewViewModel(query: query.asDriver(), locationService: locationService)
        
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests for Locations
    
    func testLocations_HasLocations() {
        // Create Subscription
        let observable = viewModel.locations.asObservable().subscribeOn(scheduler)
        
        query.accept("Brus")
        
        let result = try! observable.skip(1).toBlocking().first()!
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 1)
        
        let location = result.first!
        
        XCTAssertEqual(location.name, "Brussels")
    }
    
    func testLocations_NoLocations() {
        // Create Subscription
        let observable = viewModel.locations.asObservable().subscribeOn(scheduler)
        
        let result: [Location] = try! observable.toBlocking().first()!
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 0)
    }
    
    // MARK: - Tests for Location At Index
    
    func testLocationAtIndex_NonNil() {
        // Create Subscription
        let observable = viewModel.locations.asObservable().subscribeOn(scheduler)
        
        // Set Query
        query.accept("Brus")
        
        // Fetch Result
        let _ = try! observable.skip(1).toBlocking().first()!
        
        // Fetch Location
        let result = viewModel.location(index: 0)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.name, "Brussels")
        
    }
    
    func testLocationAtIndex_Nil() {
        // Create Subscription
        let observable = viewModel.locations.asObservable().subscribeOn(scheduler)
        
        // Set Query
        query.accept("Brus")
        
        // Fetch Result
        let _ = try! observable.skip(1).toBlocking().first()!
        
        // Fetch Location
        let result = viewModel.location(index: 1)
        
        XCTAssertNil(result)
    }
    
}







