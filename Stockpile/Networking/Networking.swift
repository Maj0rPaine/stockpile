//
//  Networking.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation

protocol ImageProvider {
    func search(query: String, scope: SearchScope, completion: @escaping ([Photo]?) -> Void)
}

class Networking {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// TODO: Download and cache image URLs
extension Networking: ImageProvider {
    func search(query: String, scope: SearchScope, completion: @escaping ([Photo]?) -> Void) {
        guard let request = Resource.search(query: query, scope: scope).request() else {
            completion(nil)
            return
        }
        
        self.session.dataTask(with: request) { (data, _, _) in
            var decodable: DecodablePhoto?
            
            if scope == .photos {
                decodable = data?.decode(PhotoResults.self)
            } else {
                decodable = data?.decode(CollectionResults.self)
            }
            
            completion(decodable?.photos)
        }.resume()
    }
}
