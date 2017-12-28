import Foundation

struct Default {
    
    static let Latitude: Double = 37.8267
    static let Longitude: Double = -122.423
    
}

struct API {
    static let APIKey = "00f4f114d381cbb3f90b86a9dd212a2d"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
}
