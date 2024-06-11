//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 25.04.2024.
//

import UIKit
import CoreLocation

protocol SearchViewControllerDelegate {
    func setNewWeatherValue(from nameLocation: String)
}

class WeatherViewController: UIViewController {

    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherForecastTableView: UITableView!
    
    private let locationManager = CLLocationManager()
    private var activityIndicator: UIActivityIndicatorView?
    
    private var weatherData: Weather? {
        didSet {
            updateUI()
        }
    }
    
    private var currentLocationLabelIsHidden = true
    
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
    
    
    private func updateUI() {
        guard let weatherData = weatherData else {
            title = "Weather information not available"
            tempLabel.text = "- -"
            feelsLikeLabel.isHidden = true
            weatherDescriptionLabel.isHidden = true
            weatherImage.isHidden = true
            return
        }
        title = weatherData.location.name
        tempLabel.text = String(format: "%.0f°", weatherData.current.tempC)
        feelsLikeLabel.text = String(format: "Feels like: %.0f°", weatherData.current.feelsLikeC)
        weatherDescriptionLabel.text = weatherData.current.condition.text
        currentLocationLabel.isHidden = currentLocationLabelIsHidden ? true : false
        getImage(from: weatherData.current.condition.icon)
        weatherForecastTableView.reloadData()
    }
    
    
    private func getWeather(from query: String) {
        NetworkManager.shared.fetchWeather(
            from: "\(Link.weatherURL.rawValue)\(query)") { [weak self] result in
                switch result {
                case .success(let weatherData):
                    self?.weatherData = weatherData
                case .failure(let error):
                    print("error 7")
                    print(error)
                }
            }
    }
    
    private func getImage(from query: String) {
        NetworkManager.shared.fetchImage(from: "https:\(query)") { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.weatherImage.image = UIImage(data: imageData)
                self?.activityIndicator?.stopAnimating()
            case .failure(let error):
                let defaultImage = UIImage(
                    systemName: "thermometer.medium",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 130, weight: .light, scale: .small)
                )
                DispatchQueue.main.async {
                    self?.weatherImage.image = defaultImage
                    self?.activityIndicator?.stopAnimating()
                }
                print("error 8")
                print(error)
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
    func setNewWeatherValue(from nameLocation: String) {
        getWeather(from: nameLocation)
        currentLocationLabelIsHidden = true
    }
}

//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData?.forecast.forecastDay.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let weatherForecast = weatherData?.forecast.forecastDay[indexPath.row]
        content.text = weatherForecast?.date
        content.textProperties.color = .white
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "3-day forecast" : ""
    }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        getWeather(from: "\(lat),\(lon)")
//        getWeather(from: "\(lat)")
        currentLocationLabelIsHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error 4")
        print(error)
    }
}

