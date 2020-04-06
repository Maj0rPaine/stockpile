//
//  UIStackView+Label.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

extension UIStackView {
    class func titleDetail(title: String, detail: String?) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.text = title
        
        let detailLabel = UILabel()
        detailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailLabel.text = detail ?? ""
        detailLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }
}
