//
//  extension + UIView.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 29.04.2024.
//

import UIKit

extension UIView {
    func addVerticalGradientLayer() {
        let primaryColor = UIColor(
            red: 135/255,
            green: 206/255,
            blue: 235/255,
            alpha: 1
        )
        
        let secondaryColor = UIColor(
            red: 107/255,
            green: 148/255,
            blue: 230/255,
            alpha: 0.6
        )
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [primaryColor.cgColor, secondaryColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
}
