//
//  Weather.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 06.05.2024.
//

struct Weather: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}

struct Current: Decodable {
    let tempC: Double
    let condition: Condition
    let feelslikeC: Double
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

