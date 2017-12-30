import UIKit

struct SettingViewTemperatureViewModel {
    let temperatureNotation: TemperatureNotation
    
    var text: String {
        switch temperatureNotation {
        case .fahrenheit:
            return "Fahrenheit"
        case .celsius:
            return "Celcius"
        }
    }
    
    var accessoryType: UITableViewCellAccessoryType {
        if UserDefaults.getTemperatureNotation() == temperatureNotation {
            return .checkmark
        } else {
            return .none
        }
    }
}
