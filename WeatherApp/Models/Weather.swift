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
    let country: String
    let lat: Double
    let lon: Double
}

struct Current: Decodable {
    let tempC: Double
    let condition: Condition
    let feelsLikeC: Double
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition = "condition"
        case feelsLikeC = "feelslike_c"
    }
}

struct Forecast: Decodable {
    let forecastDay: [ForecastDay]
    
    enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let maxTempC: Double
    let minTempC: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTempC = "maxtemp_c"
        case minTempC = "mintemp_c"
        case condition = "condition"
    }
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}


