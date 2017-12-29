import Foundation

enum DataManagerError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
    
}

final class DataManger {
    
    typealias WeatherDataCompletion = (WeatherData?, DataManagerError?) -> ()
    
    let baseURL: URL
    
    // MARK: - Initialization
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - RequestData
    
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        
        // CreateURL
        let URL = baseURL.appendingPathComponent("\(latitude),\(longitude)")
        print(URL)
        // Create Data Task
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
}

private extension DataManger {
    func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unknown)
        }
    }
    
    func processWeatherData(data: Data, completion: WeatherDataCompletion) {
        do {
            // Decode JSON
            let weatherData: WeatherData = try JSONDecode.decode(data: data)
            
            // Invoke Completion Handler
            completion(weatherData, nil)
        } catch {
            
            print(error)
            // Invoke Completion Handler
            completion(nil, .invalidResponse)
        }
    }
    
}
