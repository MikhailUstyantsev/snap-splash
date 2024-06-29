//
//  SearchViewModel.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 26.06.2024.
//

import UIKit
import Combine

final class SearchViewModel: NSObject, UISearchResultsUpdating {
    
    var apiResponse = CurrentValueSubject<[Snap], Never>([])
    @Published var searchText = ""
    let title = Constants.String.snapSplash
    
    
    func getPhotos(matching request: String) {
        guard let url = Endpoint.searchPhotos(matching: request).url else {
            return
        }
        
        Task {
            let response = try? await NetworkManager.shared.retrievePhotos(from: url)
            guard let response else { return }
            apiResponse.value = response.results
        }
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        searchText = text
    }
    
}
