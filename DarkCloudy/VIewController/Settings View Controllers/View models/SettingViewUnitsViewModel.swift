import UIKit

struct SettingViewUnitsViewModel {
    let unitsNotation: UnitsNotation
    
    var text: String {
        switch unitsNotation {
        case .imperial:
            return "Imperial"
        case .metric:
            return "Metric"
        }
    }
    
    var accessoryType: UITableViewCellAccessoryType {
        if UserDefaults.getUnitsNotation() == unitsNotation {
            return .checkmark
        } else {
            return .none
        }
    }
}
