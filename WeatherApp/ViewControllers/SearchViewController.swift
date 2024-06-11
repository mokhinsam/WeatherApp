//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 29.05.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultsTableView: UITableView!
    
    var delegate: SearchViewControllerDelegate?
    private var searchResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchBar.delegate = self
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LocalSearchManager.shared.search(text: searchText) { [unowned self] results in
            searchResults = results.map {
                !$0.subtitle.isEmpty ?
                "\($0.title), \($0.subtitle)"
                : "\($0.title)"
            }
            searchResultsTableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let searchResult = searchResults[indexPath.row]
        content.text = searchResult
        content.textProperties.color = .white
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        delegate?.setNewWeatherValue(from: searchResult)
        dismiss(animated: true)
    }
}
