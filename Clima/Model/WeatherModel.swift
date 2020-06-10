//
//  WeatherModel.swift
//  Clima
//
//  Created by Nadeem Ansari on 6/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let id: Int
    let city: String
    let temperature: Double
    let description: String
    
    init(_ id: Int, _ city: String, _ temp: Double, _ desc: String) {
        self.id = id
        self.city = city
        self.temperature = temp
        self.description = desc
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch id {
        case 200...232:
            // Thunderstorms
            return "cloud.bolt"
        case 300...321:
            // Drizzle
            return "cloud.drizzle"
        case 500...531:
            // Rain
            return "cloud.rain"
        case 600...622:
            // Snow
            return "cloud.snow"
        case 701...781:
            // Atmosphere
            return "cloud.fog"
        case 800:
            // Clear
            return "sun.min"
        case 801...804:
            // Clouds
            return "cloud"
        default:
            return "sun.max"
        }
    }
}
