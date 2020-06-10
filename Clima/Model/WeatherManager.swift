//
//  WeatherManager.swift
//  Clima
//
//  Created by Nadeem Ansari on 6/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(with weatherModel: WeatherModel)
    func didFailWith(_ error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=f77aad964758f014c014a485cff0fbeb&units=imperial"
    
    var delegate: WeatherManagerDelegate? = nil
    
    func fetchWeather(for cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let urlSession = URLSession(configuration: .default)
        let urlSessionTask = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWith(error)
                return
            }
            guard let safeData = data else { return }
            guard let safeWeatherModel = self.parseJSON(safeData) else { return }
            self.delegate?.didUpdateWeather(with: safeWeatherModel)
        }
        urlSessionTask.resume()
    }
    
    private func parseJSON(_ weatherData:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let condId = decodedData.weather[0].id
            let city = decodedData.name
            let temp = decodedData.main.temp
            let desc = decodedData.weather[0].description
            let weatherModel = WeatherModel(condId, city, temp, desc)
            return weatherModel
        } catch {
            delegate?.didFailWith(error)
            return nil
        }
    }
}
