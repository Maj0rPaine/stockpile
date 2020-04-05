//
//  Photos.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation

protocol DecodablePhoto: Decodable {
    var total: Int? { get }
    var photos: [Photo]? { get }
    var nextURL: URL? { get set }
}

struct PhotoResults: DecodablePhoto {
    let total: Int?
    let photos: [Photo]?
    var nextURL: URL?
    
    enum RootKeys: String, CodingKey {
        case total
        case photos = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        photos = try container.decode([Photo].self, forKey: .photos)
    }
}

struct CollectionResults: DecodablePhoto {
    let total: Int?
    let photos: [Photo]?
    var nextURL: URL?
    
    enum RootKeys: String, CodingKey {
        case total
        case results
    }
    
    enum PhotoKeys: String, CodingKey {
        case photos = "cover_photo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        
        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        var photoArray = [Photo]()
        
        // We want to map cover_photo object to match PhotoResults schema
        while !nestedContainer.isAtEnd {
            let photoContainer = try nestedContainer.nestedContainer(keyedBy: PhotoKeys.self)
            photoArray.append(try photoContainer.decode(Photo.self, forKey: .photos))
        }
        photos = photoArray
    }
}

struct Photo: Decodable {
    let id: String?
    let width: Int?
    let height: Int?
    let color: String?
    let description: String?
    let urls: Urls?
}

struct Urls: Decodable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
