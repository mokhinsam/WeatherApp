//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 25.04.2024.
//

import UIKit

class WeatherViewController: UIViewController {

    

    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var minMaxLabel: UILabel!
    @IBOutlet var weatherForecastTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForecastTableView.dataSource = self
        
        view.addVerticalGradientLayer()
        
        setupNavigationBar()
        
        
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
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
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



