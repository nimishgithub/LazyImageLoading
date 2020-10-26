//
//  SearchModel.swift
//
//  Created by Admin on 23/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

// MARK: - Rsponse
struct SearchResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    var imageUrl: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}
