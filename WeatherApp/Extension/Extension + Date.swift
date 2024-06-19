//
//  Extension + Date.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 17.06.2024.
//

import Foundation

extension Date {
    var toApiString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var getWeekday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self)
    }
}
