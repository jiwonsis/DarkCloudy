import CoreLocation

class Geocoder: LocationService {
    
    private lazy var geocoder = CLGeocoder()
    
    func geocode(addressString: String?, completionHandler: @escaping LocationService.LocationServiceCompletionHandler) {
        guard let addressString = addressString else {
            completionHandler([], nil)
            return
        }
        
        // Decode Address String
        geocoder.geocodeAddressString(addressString) { (placeMarks, error) in
            if let error = error {
                completionHandler([], nil)
                print("Unable to Forward Geocode Address (\(error))")
            } else if let _placeMarks = placeMarks {
                // Update Locations
                let locations = _placeMarks.flatMap({ (placeMark) -> Location? in
                    guard let name = placeMark.name else { return nil }
                    guard let location = placeMark.location else { return nil }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                })
                
                completionHandler(locations, nil)
            }
        }
    }
}
