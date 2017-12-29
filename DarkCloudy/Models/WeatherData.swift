import Foundation

struct WeatherData {
    let time: Date
    let city: String
    
    let lat: Double
    let long: Double
    let windSpeed: Double
    let temperature: Double
    
    let icon: String
    let summary: String
    
    let dailyData: [WeatherDayData]
}

extension WeatherData: JSONDecodable {
    init(decoder: JSONDecode) throws {
        let time: Double = try decoder.decode(key: "currently.time")
        self.time = Date(timeIntervalSince1970: time)
        
        self.city = try decoder.decode(key: "timezone")
        self.lat = try decoder.decode(key: "latitude")
        self.long = try decoder.decode(key: "longitude")
        self.windSpeed = try decoder.decode(key: "currently.windSpeed")
        self.temperature = try decoder.decode(key: "currently.temperature")
        self.icon = try decoder.decode(key: "currently.icon")
        self.summary = try decoder.decode(key: "currently.summary")
        self.dailyData = try decoder.decode(key: "daily.data")
    }
}
