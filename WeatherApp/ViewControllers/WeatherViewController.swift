//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 25.04.2024.
//

import UIKit

protocol SearchViewControllerDelegate {
    func setNewWeatherValue(from nameLocation: String)
}

class WeatherViewController: UIViewController {

    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherForecastTableView: UITableView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var errorDescriptionLabel: UILabel!
    
    private var imageActivityIndicator: UIActivityIndicatorView?
    private var loadingActivityIndicator: UIActivityIndicatorView?
    private var currentLocationLabelIsHidden = true
    private var weatherData: Weather? {
        didSet {
            setupUI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForecastTableView.dataSource = self
        requestLocation()
        
        view.addVerticalGradientLayer()
        loadingView.addVerticalGradientLayer()
        setupNavigationBar()
        
        loadingActivityIndicator = showActivityIndicator(in: loadingView, style: .large)
        imageActivityIndicator = showActivityIndicator(in: weatherImage, style: .medium)
        
        errorDescriptionLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchVC = segue.destination as? SearchViewController else { return }
        searchVC.delegate = self
    }
    
    @IBAction func locationButtonDidPressed(_ sender: UIBarButtonItem) {
        showLoadingView()
        requestLocation()
        currentLocationLabelIsHidden = false
    }
}

//MARK: - Setup UI
extension WeatherViewController {
    private func setupUI() {
        guard let weatherData = weatherData else { return }
        print("setupUI GO")
        title = weatherData.location.country
        cityLabel.text = weatherData.location.name
        tempLabel.text = String(format: "%.0f°", weatherData.current.tempC)
        feelsLikeLabel.text =
        String(format: "Feels like: %.0f°", weatherData.current.feelsLikeC)
        weatherDescriptionLabel.text = weatherData.current.condition.text
        currentLocationLabel.isHidden = 
        currentLocationLabelIsHidden ? true : false
        getWeatherImage(from: weatherData.current.condition.icon)
        weatherForecastTableView.reloadData()
    }
    
    
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir Medium", size: 17) 
            ?? UIFont.systemFont(ofSize: 17)
        ]
        navBarAppearance.shadowColor = .clear
        navBarAppearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func showActivityIndicator(
        in view: UIView,
        style: UIActivityIndicatorView.Style
    ) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }

    
    private func showLoadingView() {
        title = ""
        loadingView.isHidden = false
        loadingActivityIndicator?.startAnimating()
        errorDescriptionLabel.isHidden = true
    }
    
    private func hideLoadingView() {
        loadingView.isHidden = true
        loadingActivityIndicator?.stopAnimating()
    }
}

//MARK: - Networking
extension WeatherViewController {
    private func getWeather(from query: String) {
        NetworkManager.shared.fetchWeather(
            from: "\(Link.weatherURL.rawValue)\(query)"
        ) { [weak self] result in
                switch result {
                case .success(let weatherData):
                    self?.weatherData = weatherData
//                    self?.hideLoadingView()
                    print("getWeather GO")
                case .failure(let error):
                    print("error 7")
                    print(error)
                }
            }
    }
    
    private func getWeatherImage(from query: String) {
        NetworkManager.shared.fetchImage(from: "https:\(query)") { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.weatherImage.image = UIImage(data: imageData)
                self?.imageActivityIndicator?.stopAnimating()
            case .failure(let error):
                let defaultImage = UIImage(
                    systemName: "thermometer.medium",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 130, weight: .light, scale: .small)
                )
                DispatchQueue.main.async {
                    self?.weatherImage.image = defaultImage
                    self?.imageActivityIndicator?.stopAnimating()
                }
                print("error 8")
                print(error)
            }
        }
    }
}

//MARK: - Location
extension WeatherViewController {
    private func requestLocation() {
        LocationManager.shared.requestLocation { [weak self] location, error in
            guard let location = location else {
                guard let error = error else { return }
                print("FUCKING ERROR")
                self?.showLoadingView()
                self?.loadingActivityIndicator?.stopAnimating()
                self?.errorDescriptionLabel.isHidden = false
                self?.errorDescriptionLabel.text =
                """
                Something went wrong.
                Please, check your internet connection and try again.
                """
                
//                switch error.code {
//                case 0:
//                    self?.errorDescriptionLabel.text = "error 13 at getErrorLocation"
//                default:
//                    self?.errorDescriptionLabel.text = "чет случилось"
//                }
                return
            }
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self?.getWeather(from: "\(lat),\(lon)")
            self?.currentLocationLabelIsHidden = false
            self?.hideLoadingView()
        }
    }
}

//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData?.forecast.forecastDay.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell", for: indexPath)
        guard let cell = cell as? WeatherForecastCell else { return UITableViewCell() }
        guard let weatherData = weatherData else { return UITableViewCell() }
        let weatherForecast = weatherData.forecast.forecastDay[indexPath.row]
        cell.configure(with: weatherForecast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "3-day forecast"
    }
}

//MARK: - SearchViewControllerDelegate
extension WeatherViewController: SearchViewControllerDelegate {
    func setNewWeatherValue(from nameLocation: String) {
        showLoadingView()
        LocationManager.shared.getCoordinate(from: nameLocation) { [weak self] location, error in
            guard error == nil else {
                guard let error = error else { return }
                print("Error 12:")
                print(error.code)
                print(error.localizedDescription)
                if error.code == 8 {
                    self?.errorDescriptionLabel.isHidden = false
                    self?.errorDescriptionLabel.text = ""
                }
                return
            }
            self?.getWeather(from: "\(location.latitude),\(location.longitude)")
            self?.currentLocationLabelIsHidden = true
            self?.hideLoadingView()
        }
    }
}
