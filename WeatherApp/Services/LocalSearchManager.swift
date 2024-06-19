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
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.query, .address])
    }
    
    func search(text: String, onSearch: @escaping (([MKLocalSearchCompletion]) -> Void)) {
        searchCompleter.queryFragment = text
        self.onSearch = onSearch
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocalSearchManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        onSearch?(searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print("error 5")
        print(error)
        print(error.localizedDescription)
    }
}
