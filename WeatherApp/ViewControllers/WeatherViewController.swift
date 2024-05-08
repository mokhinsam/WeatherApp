//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 25.04.2024.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherForecastTableView: UITableView!
    
    private var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForecastTableView.dataSource = self
        view.addVerticalGradientLayer()
        
        fetchWeather()
        setupNavigationBar()
        activityIndicator = showActivityIndicator(in: weatherImage)
    }
    

    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir Medium", size: 40) ?? UIFont.systemFont(ofSize: 40)
        ]
        navBarAppearance.shadowColor = .clear
        navBarAppearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 20)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func fetchWeather() {
        NetworkManager.shared.fetchWeather(from: "\(Link.weatherURL.rawValue)Moscow") { [weak self] weather in
            self?.title = weather.location.name
            self?.tempLabel.text = String(format: "%.0f°", weather.current.tempC)
            self?.feelsLikeLabel.text = String(format: "Feels like: %.0f°", weather.current.feelslikeC)
            self?.weatherDescriptionLabel.text = weather.current.condition.text
            NetworkManager.shared.fetchImage(from: "https:\(weather.current.condition.icon)") { [weak self] imageData in
                self?.weatherImage.image = UIImage(data: imageData)
                self?.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }

}

//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Cell"
        cell.contentConfiguration = content
        return cell
    }
    
    
    
}



