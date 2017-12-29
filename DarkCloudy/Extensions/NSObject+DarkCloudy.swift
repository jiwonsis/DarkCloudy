import Foundation

extension NSObject {
    static var nibName: String {
        return String(describing: self)
    }
}
