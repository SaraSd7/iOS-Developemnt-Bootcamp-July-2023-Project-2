//
//  WeatheViewModel.swift
//  WWAPI
//
//  Created by Sara Sd on 03/02/1445 AH.
//

import Foundation
import SwiftUI
import CoreData

class WeatheViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var viewContext
    
    @Published var cityName: String = ""
    @Published var weatherData: WeatherData?
    @Published var unitSelection: Int = 0
    @Published var error: String?
    @Published var isNight = false
    
    func displayWeatherIcon(id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
        
    }
    
    func fetchWeatherData() {
        guard !cityName.isEmpty else {
            error = "Please enter a city name"
            return
        }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=\(unitSelection == 0 ? "metric" : "imperial")&appid=d74e45f0a6cf7f29444ed0bf1e8a69b7") else {
            error = "Invalid API URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                self.error = error?.localizedDescription ?? "Unknown error"
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = weatherData
                    self.error = nil
                }
            } catch {
                self.error = "Error decoding weather data: \(error.localizedDescription)"
            }
        }.resume()
    }
    
    func fetchWeatherByLocation(locationManager: LocationManager) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(locationManager.region.center.latitude)&lon=\(locationManager.region.center.longitude)&appid=d74e45f0a6cf7f29444ed0bf1e8a69b7") else {
            error = "Invalid API URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                self.error = error?.localizedDescription ?? "Unknown error"
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = weatherData
                    self.error = nil
                }
            } catch {
                self.error = "Error decoding weather data: \(error.localizedDescription)"
            }
        }.resume()
    }
}

