//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//  

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextfield.delegate = self
        weatherManager.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextfield.resignFirstResponder()
    }
    
    @IBAction func forceFetchLocationWeatherPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        weatherManager.fetchWeather(lat: last.coordinate.latitude, lon: last.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location")
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextfield.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type something"
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text != "" else { return }
        guard let city = textField.text else { return }
        weatherManager.fetchWeather(for: city)
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func weatherManager(_ manager: WeatherManager, didUpdateWeatherWith weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherModel.temperatureString
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.cityLabel.text = weatherModel.city
            self.weatherDescriptionLabel.text = weatherModel.description
            self.searchTextfield.text = weatherModel.city
        }
    }
    
    func didFailWith(_ manager: WeatherManager, _ error: Error) {
        print(error)
    }
}
