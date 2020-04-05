//
//  Resource.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation

struct Resource {
    var path: String
    
    var queryItems: [URLQueryItem]?
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

extension Resource {
    static func searchPhotos(query: String) -> Resource {
        let path = "/search/photos"
        return Resource(
            path: path,
            queryItems: [
                URLQueryItem(name: "query", value: query)
            ])
    }
    
    static func searchCollections(query: String) -> Resource {
        let path = "/search/collections"
        return Resource(
            path: path,
            queryItems: [
                URLQueryItem(name: "query", value: query)
            ])
    }
    
    func request() -> URLRequest? {
        return URLRequest.authorized(url: self.url)
    }
}

extension URLRequest {
    static func authorized(url: URL?) -> URLRequest? {
        guard let url = url else { return nil }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID r8RfyeA8XqFuT6u0DuZ7aIrxByzSbHOxvtJUCd-5wZ4", forHTTPHeaderField: "Authorization")
        
        print("Request: ", request.url?.absoluteString ?? "None")

        return request
    }
}
