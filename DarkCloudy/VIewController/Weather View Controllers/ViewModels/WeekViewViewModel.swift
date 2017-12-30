import UIKit

struct WeekViewViewModel {
    
    // MARK: - Properties
    
    let weatherData: [WeatherDayData]
    
    // MARK: -
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDay: Int {
        return weatherData.count
    }
    
    // MARK: - Methods
    
    func viewModel(for index: Int) -> WeatherDayViewViewModel {
        return WeatherDayViewViewModel(weatherDayData: weatherData[index])
    }
    
}
