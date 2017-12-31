import UIKit

struct SettingsViewTemperatureViewModel {
    let temperatureNotation: TemperatureNotation
    
    var text: String {
        switch temperatureNotation {
        case .fahrenheit:
            return "Fahrenheit"
        case .celsius:
            return "Celsius"
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

extension SettingsViewTemperatureViewModel: SettingsRepresentable {
    
}
