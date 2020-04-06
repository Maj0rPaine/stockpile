//
//  ImageInfoViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class ImageInfoViewController: UIViewController {
    var photo: Photo!
    
    convenience init(photo: Photo) {
        self.init(nibName: nil, bundle: nil)
        self.photo = photo
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Info", comment: "")
        view.backgroundColor = .systemBackground
        
        buildStackView()
    }
    
    func buildStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        //stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.addArrangedSubview(UIStackView.titleDetail(title: "ID", detail: photo?.id))
        stackView.addArrangedSubview(UIStackView.titleDetail(title: "Created", detail: photo?.created_at?.fullDate()))
        stackView.addArrangedSubview(UIStackView.titleDetail(title: "Dimension", detail: photo.dimension))
        stackView.addArrangedSubview(UIStackView.titleDetail(title: "Color", detail: photo?.color))
        stackView.addArrangedSubview(UIStackView.titleDetail(title: "Description", detail: photo?.description))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
