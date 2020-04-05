//
//  Networking.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ImageProvider {
    func fetch<PhotoType: DecodablePhoto>(resource: Resource, completion: @escaping (PhotoType?) -> Void)
    func nextPage<PhotoType: DecodablePhoto>(nextURL: URL?, completion: @escaping (PhotoType?) -> Void)
    func getImage(url: URL, completion: @escaping (UIImage?) -> Void)
}

class Networking {
    typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    let session: URLSession
        
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func parseNextURLHeader(completion: @escaping (Data?, URL?) -> Void) -> DataTaskCompletionHandler {
        return { data, response, _ in
            var nextURL: URL?
            
            if let response = response as? HTTPURLResponse,
                let linkHeader = response.value(forHTTPHeaderField: "Link") {
                nextURL = linkHeader.nextURL()
            }
            
            completion(data, nextURL)
        }
    }
}

// TODO: Download and cache image URLs
extension Networking: ImageProvider {
    func fetch<PhotoType: DecodablePhoto>(resource: Resource, completion: @escaping (PhotoType?) -> Void) {
        guard let request = resource.request() else {
            completion(nil)
            return
        }
        
        self.session.dataTask(with: request, completionHandler: self.parseNextURLHeader(completion: { data, nextURL in
            // FIXME: Extend DecodablePhoto
            var decoded = data?.decode(PhotoType.self)
            decoded?.nextURL = nextURL
            completion(decoded)
        })).resume()
    }
    
    func nextPage<PhotoType: DecodablePhoto>(nextURL: URL?, completion: @escaping (PhotoType?) -> Void) {
        guard let request = URLRequest.authorized(url: nextURL) else {
            completion(nil)
            return
        }
            
        self.session.dataTask(with: request, completionHandler: self.parseNextURLHeader(completion: { data, nextURL in
            // FIXME: Extend DecodablePhoto
            var decoded = data?.decode(PhotoType.self)
            decoded?.nextURL = nextURL
            completion(decoded)
        })).resume()
    }
    
    func getImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = UIImage.imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            print("Cached Image url: ", url.absoluteString)
            completion(cachedImage)
            return
        }
        
        print("Image url: ", url.absoluteString)

        // TODO: Keep track of these tasks
        self.session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
                image.cache(with: url.absoluteString)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

extension String {
    /// Parse comma delimited URLs (e.g., <https://api.unsplash.com/search/photos?page=1&query=dogs>; rel="first", <https://api.unsplash.com/search/photos?page=3&query=dogs>; rel="next")
    func nextURL() -> URL? {
        return self.components(separatedBy: ",")
            .first(where: { $0.contains("rel=\"next\"") })?
            .components(separatedBy: ";")
            .compactMap { URL(string: $0.replacingOccurrences(of: "[<> ]", with: "", options: .regularExpression)) }
            .first
    }
}

extension UIImage {
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    func cache(with key: String) {
        UIImage.imageCache.setObject(self, forKey: key as AnyObject)
    }
}
