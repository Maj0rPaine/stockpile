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
    static func search(query: String, scope: SearchScope) -> Resource {
        let path = "/search/\(scope.description)"
        return Resource(
            path: path,
            queryItems: [
                URLQueryItem(name: "query", value: query)
            ])
    }
    
    func request() -> URLRequest? {
        guard let url = self.url else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID r8RfyeA8XqFuT6u0DuZ7aIrxByzSbHOxvtJUCd-5wZ4", forHTTPHeaderField: "Authorization")
        return request
    }
}
