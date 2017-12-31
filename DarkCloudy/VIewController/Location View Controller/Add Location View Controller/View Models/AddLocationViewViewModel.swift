import Foundation
import CoreLocation

class AddLocationViewViewModel {
    
    var query: String = "" {
        didSet {
            geocode(addressString: query)
        }
    }
    
    var queryingDidChange: ((Bool) -> ())?
    var locationDidChange: (([Location]) -> ())?
    
    private var querying: Bool = false {
        didSet {
            queryingDidChange?(querying)
        }
    }
    private var locations: [Location] = [] {
        didSet {
            locationDidChange?(locations)
        }
    }
    
    var hasLocation: Bool { return numberOfLocations > 0 }
    var numberOfLocations: Int { return locations.count }
    
    private lazy var geocoder = CLGeocoder()
    
    func location(index: Int) -> Location? {
        guard index < locations.count else { return nil }
        return locations[index]
    }
    
    func viewModelForLocation(index: Int) -> LocationRepresentable? {
        guard let location = location(index: index) else { return nil }
        return LocationsViewLocationViewModel(location: location.location, locationAsString: location.name)
    }
    
}

private extension AddLocationViewViewModel {
    
    func geocode(addressString: String?) {
        guard let addressString = addressString, !addressString.isEmpty  else {
            locations = []
            return
        }
        
        querying = true
        
        geocoder.geocodeAddressString(addressString) { [weak self] (placeMarks, error) in
            var locations: [Location] = []
            
            self?.querying = false
            
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
            } else if let placeMarks = placeMarks {
                locations = placeMarks.flatMap({ (placeMark) -> Location? in
                    guard let name = placeMark.name else { return nil }
                    guard let location = placeMark.location else { return nil }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                })
            }
            
            self?.locations = locations
        }
    }
}
