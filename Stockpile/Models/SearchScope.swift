//
//  SearchScope.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation

enum SearchScope: Int {
    case photos = 0
    case collections = 1
    
    static var buttonTitles: [String] {
        return [
            NSLocalizedString("Photos", comment: ""),
            NSLocalizedString("Collections", comment: "")
        ]
    }
}
