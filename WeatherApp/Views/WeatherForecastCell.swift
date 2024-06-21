//
//  WeatherForecastCell.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 11.06.2024.
//

import UIKit

class WeatherForecastCell: UITableViewCell {

    @IBOutlet var weekdayLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var minMaxTempLabel: UILabel!
    
    func configure(with weatherForecast: ForecastDay) {
        weekdayLabel.text = getWeekdayName(from: weatherForecast.date)
        minMaxTempLabel.text = weatherForecast.day.minTempC.description.count == 3 ?
        "↓0\(weatherForecast.day.minTempC)° ↑\(weatherForecast.day.maxTempC)°"
        : "↓\(weatherForecast.day.minTempC)° ↑\(weatherForecast.day.maxTempC)°"
        getWeatherImage(from: weatherForecast.day.condition.icon)
    }
}

//MARK: - Private Methods
extension WeatherForecastCell {
    private func getWeekdayName(from apiDate: String) -> String {
        guard let date = dateFromString(apiDate) else { return "" }
        let currentDate = Date().toApiString
        return currentDate == apiDate ? "Today" : date.getWeekday
    }
    
    private func dateFromString(_ apiString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: apiString)
    }

    private func getWeatherImage(from query: String) {
        NetworkManager.shared.fetchImage(from: "https:\(query)") { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.weatherImage.image = UIImage(data: imageData)
            case .failure(let error):
                let defaultImage = UIImage(
                    systemName: "thermometer.medium",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 130, weight: .light, scale: .small)
                )
                DispatchQueue.main.async { [weak self] in
                    self?.weatherImage.image = defaultImage
                }
                print("error 11")
                print(error)
            }
        }
    }
}
