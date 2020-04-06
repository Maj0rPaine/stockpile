//
//  ImageDetailViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit
import LinkPresentation

class ImageDetailViewController: UIViewController {
    var photo: Photo!
    
    let imageProvider: ImageProvider = Networking()
    
    var metadata: LPLinkMetadata?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        return imageView
    }()
    
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
        view.backgroundColor = .systemBackground
        fetchMetaData()
        loadImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbarItems = [
            UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(showInfo)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(sharePhoto(_:)))
        ]
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func loadImage() {
        guard let stringURL = photo.urls?.regular,
            let url = URL(string: stringURL) else { return }
        
        imageProvider.getImage(url: url) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    @objc func showInfo() {
        let controller = UINavigationController(rootViewController: ImageInfoViewController(photo: photo))
        present(controller, animated: true, completion: nil)
    }
}

extension ImageDetailViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Unsplash"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return self.metadata?.url
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return self.metadata
    }
    
    func fetchMetaData() {
        guard let stringURL = photo.links?.html,
            let url = URL(string: stringURL) else { return }
        
        LPMetadataProvider().startFetchingMetadata(for: url) { linkMetadata, _ in
            linkMetadata?.iconProvider = linkMetadata?.imageProvider
            self.metadata = linkMetadata
        }
    }
    
    @objc func sharePhoto(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        activityViewController.popoverPresentationController?.canOverlapSourceViewRect = true
        activityViewController.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        self.present(activityViewController, animated: true)
    }
}
