import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class AddLocationViewViewModel {
    
    // MARK: - Properties
    
    var hasLocation: Bool { return numberOfLocations > 0 }
    var numberOfLocations: Int { return _locations.value.count }
    
    private let _locations = BehaviorRelay<[Location]>(value: [])
    private let _querying = BehaviorRelay<Bool>(value: false)
    
    var locations: Driver<[Location]> { return _locations.asDriver() }
    var querying: Driver<Bool> { return _querying.asDriver() }
    
    // MARK: -
    
    private lazy var geocoder = CLGeocoder()
    
    private let disposeBag = DisposeBag()
    
    init(query: Driver<String>) {
        query
            .throttle(0.5)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (addressString) in
                self?.geocode(addressString: addressString)
            })
            .disposed(by: disposeBag)
        
    }
    
    func location(index: Int) -> Location? {
        guard index < _locations.value.count else { return nil }
        return _locations.value[index]
    }
    
    func viewModelForLocation(index: Int) -> LocationRepresentable? {
        guard let location = location(index: index) else { return nil }
        return LocationsViewLocationViewModel(location: location.location, locationAsString: location.name)
    }
    
}

private extension AddLocationViewViewModel {
    
    func geocode(addressString: String?) {
        guard let addressString = addressString, !addressString.isEmpty  else {
            _locations.accept([])
            return
        }
        
        _querying.accept(true)
        
        geocoder.geocodeAddressString(addressString) { [weak self] (placeMarks, error) in
            var locations: [Location] = []
            
            self?._querying.accept(false)
            
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
            } else if let placeMarks = placeMarks {
                locations = placeMarks.flatMap({ (placeMark) -> Location? in
                    guard let name = placeMark.name else { return nil }
                    guard let location = placeMark.location else { return nil }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                })
            }
            
            self?._locations.accept(locations)
        }
    }
}
