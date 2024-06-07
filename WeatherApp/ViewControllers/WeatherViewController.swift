//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 25.04.2024.
//

import UIKit
import CoreLocation

protocol SearchViewControllerDelegate {
    func setNewWeatherValue(from: String)
}

class WeatherViewController: UIViewController {

    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherForecastTableView: UITableView!
    
    private var activityIndicator: UIActivityIndicatorView?
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForecastTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        
        view.addVerticalGradientLayer()
        
        setupNavigationBar()
        activityIndicator = showActivityIndicator(in: weatherImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchVC = segue.destination as? SearchViewController else { return }
        searchVC.delegate = self
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
        navBarAppearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func fetchWeather(from query: String) {
        NetworkManager.shared.fetchWeather(from: "\(Link.weatherURL.rawValue)\(query)") { [weak self] weather in
            self?.title = weather.location.name
            self?.tempLabel.text = String(format: "%.0f°", weather.current.tempC)
            self?.feelsLikeLabel.text = String(format: "Feels like: %.0f°", weather.current.feelsLikeC)
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

//MARK: - SearchViewControllerDelegate
extension WeatherViewController: SearchViewControllerDelegate {
    func setNewWeatherValue(from query: String) {
        fetchWeather(from: query)
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

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        fetchWeather(from: "\(lat),\(lon)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error 4")
        print(error)
    }
}

