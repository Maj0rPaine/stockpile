//
//  String+URL.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation

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
