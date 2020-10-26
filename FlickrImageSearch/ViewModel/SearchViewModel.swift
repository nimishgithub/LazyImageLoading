//
//  SearchViewModel.swift
//
//  Created by Nimish Sharma 23/08/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import Foundation

final class SearchViewModel {
    
//    MARK: Properties
    var searchResults: [Photo] = []
    var searchString = ""
    var currentPage = 0
    var totalPages = 0
    var apiInProcess = false
    
//    MARK: Handlers
    var didLoadNewResults: (()->Void) = {}
    
    //Call Method To Fetch Data From Server (From JSON file in current case)
    func fetchImageResults(_ queryString: String) {
        AppNetworking.flickrSearchService(queryString, page: (currentPage + 1)) { [weak self] result in
            guard let self = self else {return}
    
            switch result {
            case .failure(let error):
                print("Error Occured: \(error.localizedDescription)")
                
            case .success(let photos):
                self.currentPage = photos.page
                self.totalPages = photos.pages
                if photos.page == 1 {
                    ImageDownloadManager.shared.cancelAll()
                    self.searchResults = []
                }
                self.searchResults += photos.photo
                self.didLoadNewResults()
                self.apiInProcess = false
            }
            
        }
    }
    
    func loadNextBatch() {
        guard !searchString.isEmpty, !apiInProcess,
            (currentPage < totalPages) else {return}
        apiInProcess = true
        fetchImageResults(searchString)
    }
    
    func reset() {
        searchResults = []
        currentPage = 0
        totalPages = 0
        apiInProcess = false
        searchString = ""
    }
}
