import UIKit

struct WeatherDayViewViewModel {
    
    let weatherDayData: WeatherDayData
    
    private let dayFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    
    var day: String {
        dayFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: weatherDayData.time)
    }
    
    var date: String {
        dateFormatter.dateFormat = "MMMM d"
        
        return dateFormatter.string(from: weatherDayData.time)
    }
    
    var temperature: String {
        let min = format(temperature: weatherDayData.temperatureMin)
        let max = format(temperature: weatherDayData.temperatureMax)
        
        return "\(min) / \(max)"
    }
    
    var windSpeed: String {
        let windSpeed = weatherDayData.windSpeed
        
        switch UserDefaults.getUnitsNotation() {
        case .imperial:
            return String(format: "%.f MPH", windSpeed)
        case .metric:
            return String(format: "%.f KPH", windSpeed.toKPH())
        }
    }

    var image: UIImage? {
        return UIImage.imageForIcon(name: weatherDayData.icon)
    }
    
    
    private func format(temperature: Double) -> String {
        switch UserDefaults.getTemperatureNotation() {
        case .celsius:
            return String(format: "%.0f °F", temperature)
        case .fahrenheit:
            return  String(format: "%.0f °C", temperature.toCelcius())
        }
    }
}

extension WeatherDayViewViewModel: WeatherDayRepresentable {
    
    
}


