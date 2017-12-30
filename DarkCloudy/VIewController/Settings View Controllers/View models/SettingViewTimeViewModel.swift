import UIKit

struct SettingViewTimeViewModel {
    
    let timeNotation: TimeNotation
    
    var text: String {
        switch timeNotation {
        case .twelveHour:
            return "12 Hour"
        case .twentyFourHour:
            return "24 Hour"
        }
    }
    
    var accessoryType: UITableViewCellAccessoryType {
        if UserDefaults.getTimeNotation() == timeNotation {
            return .checkmark
        } else {
            return .none
        }
    }
    
    
}
