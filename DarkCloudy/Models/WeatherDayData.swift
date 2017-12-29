//
//  WeatherDayData.swift
//  DarkCloudy
//
//  Created by Scott moon on 28/12/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation

struct WeatherDayData {
    let time: Date
    let icon: String
    let windSpeed: Double
    let temperatureMin: Double
    let temperatureMax: Double
}

extension WeatherDayData: JSONDecodable {
    init(decoder: JSONDecode) throws {
        let time: Double = try decoder.decode(key: "time")
        self.time = Date(timeIntervalSince1970: time)
        
        self.icon = try decoder.decode(key: "icon")
        self.windSpeed = try decoder.decode(key: "windSpeed")
        self.temperatureMin = try decoder.decode(key: "temperatureMin")
        self.temperatureMax = try decoder.decode(key: "temperatureMax")
    }
}
