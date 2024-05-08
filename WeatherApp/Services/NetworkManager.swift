//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 06.05.2024.
//

import Foundation

enum Link: String {
    case weatherURL = "https://api.weatherapi.com/v1/forecast.json?key=5c303c75a38a46ed809102239242904&q="
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchWeather(from url: String, completion: @escaping(Weather) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("error 1")
                print(error?.localizedDescription ?? "No error description.")
                return
            }
    
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch let error {
                print("error 2")
                print(error)
            }
        }.resume()
    }
    
    func fetchImage(from url: String, completion: @escaping(Data) -> Void) {
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    completion(imageData)
                }
            } catch let error {
                print("error 3")
                print(error)
            }
        }
    }
}

