import Foundation

protocol LocationService {
    
    typealias LocationServiceCompletionHandler = ([Location], Error?) -> Void
    
    func geocode(addressString: String?, completionHandler: @escaping LocationServiceCompletionHandler)
    
}
