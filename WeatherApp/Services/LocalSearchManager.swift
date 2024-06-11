//
//  LocalSearchManager.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 30.05.2024.
//

import Foundation
import MapKit

class LocalSearchManager: NSObject {
    
    static let shared = LocalSearchManager()
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = []
    private var onSearch: (([MKLocalSearchCompletion]) -> Void)?
    
    override private init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
    }
    
    func search(text: String, onSearch: @escaping (([MKLocalSearchCompletion]) -> Void)) {
        searchCompleter.queryFragment = text
        self.onSearch = onSearch
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocalSearchManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        filtering(searchResults, from: completer)
        onSearch?(searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print("error 5")
        print(error)
        print(error.localizedDescription)
    }
}

//MARK: - Private Methods
extension LocalSearchManager {
    private func filtering(_ searchResults: [MKLocalSearchCompletion], from completer: MKLocalSearchCompleter) {
        let results = completer.results.filter { result in
            guard !result.title.contains(",") else { return false }
            guard result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil else { return false }
            guard !result.subtitle.contains("Nearby") else { return false }
            guard result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil else { return false }
            return true
        }
        self.searchResults = results
    }
}
