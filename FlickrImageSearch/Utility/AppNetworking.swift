//
//  AppNetworking.swift
//
//  Created by Nimish Sharma on 23/08/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import Foundation

enum AppNetworking {
    
    static func flickrSearchService(_ queryString: String, page: Int, completion: @escaping (Result<Photos, Error>) -> Void) {
        
        guard let searchUrl = FlickrSearchUrl(queryString, pageNo: page) else {
            completion(.failure(NSError("Unknown API Response")))
            return
        }
        
        let request = URLRequest(url: searchUrl)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let err = error {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            } else if let aData = data {
                do {
                    let response = try JSONDecoder().decode(SearchResponse.self, from: aData)
                    DispatchQueue.main.async {
                        completion(.success(response.photos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError("Unknown API Response")))
                }
            }
        }) .resume()
        
        
    }
    
    
    private static func FlickrSearchUrl(_ searchString: String, pageNo: Int) -> URL? {
        var params: [String: String] = [:]
        params[APIKeys.method] = "flickr.photos.search"
        params[APIKeys.api_key] = "062a6c0c49e4de1d78497d13a7dbb360"
        params[APIKeys.text] = searchString
        params[APIKeys.format] = "json"
        params[APIKeys.nojsoncallback] = "1"
        params[APIKeys.per_page] = "10"
        params[APIKeys.page] = "\(pageNo)"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.flickr.com"
        urlComponents.path = "/services/rest/"
        let queryItems = params.map{ URLQueryItem(name: $0.key, value: $0.value) }.filter{!$0.name.isEmpty}
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
