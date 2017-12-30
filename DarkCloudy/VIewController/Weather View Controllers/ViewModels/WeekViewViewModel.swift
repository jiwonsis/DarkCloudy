import UIKit

struct WeekViewViewModel {
    
    let weatherData: [WeatherDayData]
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDay: Int {
        return weatherData.count
    }
    
    func day(index: Int) -> String {
        let weatherDayData = weatherData[index]
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: weatherDayData.time)
    }
    
    func time(index: Int) -> String {
        let weatherDayData = weatherData[index]
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM d"
        
        return dateFormatter.string(from: weatherDayData.time)
    }
    
    func temperature(index: Int) -> String {
        let weatherDayData = weatherData[index]
        
        let min = format(temperature: weatherDayData.temperatureMin)
        let max = format(temperature: weatherDayData.temperatureMax)
        
        return "\(min) / \(max)"
    }
    
    private func format(temperature: Double) -> String {
        switch UserDefaults.getTemperatureNotation() {
        case .celsius:
            return String(format: "%.0f °F", temperature)
        case .fahrenheit:
            return  String(format: "%.0f °C", temperature.toCelcius())
        }
    }
    
    func image(index: Int) -> UIImage? {
        return UIImage.imageForIcon(name: weatherData[index].icon)
    }
}
