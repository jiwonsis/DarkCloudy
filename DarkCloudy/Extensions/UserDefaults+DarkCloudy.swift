import Foundation

enum TimeNotation: Int {
    case twelveHour
    case twentyFourHour
    
    var timeFormat: String {
        switch self {
        case .twelveHour: return "hh:mm a"
        case .twentyFourHour: return "HH:mm"
        }
    }
}

enum UnitsNotation: Int {
    case imperial
    case metric
}

enum TemperatureNotation: Int {
    case fahrenheit
    case celsius
}

struct UserDefaultsKeys {
    static let locations = "locations"
    static let timeNotation = "timeNotation"
    static let unitsNotation = "unitsNotation"
    static let temperatureNotation = "temperatureNotation"
}

extension UserDefaults {
    
    // MARK: - Timer Notation
    
    static func getTimeNotation() -> TimeNotation {
        guard let storedValue = UserDefaults.standard.object(forKey: UserDefaultsKeys.timeNotation) as? Int else { return .twelveHour }
        
        return TimeNotation(rawValue: storedValue) ?? .twelveHour
    }
    
    static func setTimeNotation(timeNotation: TimeNotation) {
        UserDefaults.standard.set(timeNotation.rawValue, forKey: UserDefaultsKeys.timeNotation)
    }
    
    // MARK: - Units Notation
    
    static func getUnitsNotation() -> UnitsNotation {
        guard let storedValue = UserDefaults.standard.object(forKey: UserDefaultsKeys.unitsNotation) as? Int else { return .imperial }
        return UnitsNotation(rawValue: storedValue) ?? .imperial
    }
    
    static func setUnitsNotation(unitsNotation: UnitsNotation) {
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: UserDefaultsKeys.unitsNotation)
    }
    
    // MARK: - Temperature Notation
    
    static func getTemperatureNotation() -> TemperatureNotation {
        guard let storedValue = UserDefaults.standard.object(forKey: UserDefaultsKeys.temperatureNotation) as? Int else { return .fahrenheit }
        return TemperatureNotation(rawValue: storedValue) ?? .fahrenheit
    }
    
    static func setTemperatureNotation(temperatureNotation: TemperatureNotation) {
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: UserDefaultsKeys.temperatureNotation)
    }

}

extension UserDefaults {
    
    // MARK: - Locations
    
    static func loadLocations() -> [Location] {
        guard let dictinaries = UserDefaults.standard.object(forKey: UserDefaultsKeys.locations) as? [[String: Any]] else { return [] }
        
        return dictinaries.flatMap({ (dictionary) -> Location? in
            return Location(dictionary: dictionary)
        })
    }
    
    static func addLocation(_ location: Location) {
        // Load Locations
        var locations = loadLocations()
        
        // Add location
        locations.append(location)
        
        // Save Locations
        saveLocations(locations)
    }
    
    static func removeLocation(_ location: Location) {
        // Load Locations
        var locations = loadLocations()
        
        // Fetch Location Index
        guard let index = locations.index(of: location) else { return }
        
        // Remove Location
        locations.remove(at: index)
        
        // Save Location
        saveLocations(locations)
    }
    
    
    // MARK: -
    private static func saveLocations(_ locations: [Location]) {
        // Transform Locations
        let dictionaries: [[String: Any]] = locations.map{ $0.asDictionary }
        
        // Save Location
        UserDefaults.standard.set(dictionaries, forKey: UserDefaultsKeys.locations)
    }
}
