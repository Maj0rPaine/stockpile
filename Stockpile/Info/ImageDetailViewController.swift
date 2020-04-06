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
    let imageProvider: ImageProvider = Networking()
    
    let dataController = DataController.shared
    
    var metadata: LPLinkMetadata?
    
    var photo: Photo?

    var favorite: Favorite?
    
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
    
    lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(saveDeleteFavorite(_:)), for: .touchUpInside)
        return button
    }()
    
    let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(showInfo))
    
    convenience init(photo: Photo) {
        self.init(nibName: nil, bundle: nil)
        self.photo = photo
        fetchMetaData()
        loadImage()
    }
    
    convenience init(favorite: Favorite) {
        self.init(nibName: nil, bundle: nil)
        self.favorite = favorite
        loadFavorite(favorite: favorite)
        infoButton.isEnabled = false
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(sharePhoto(_:)))
        
        toolbarItems = [
            infoButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(customView: favoritesButton)
        ]
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func loadImage() {
        // Check if already saved
        if let id = photo?.id,
            let savedImage = dataController.viewContext.fetchFavorite(id) {
            loadFavorite(favorite: savedImage)
            return
        }
        
        guard let stringURL = photo?.urls?.regular,
            let url = URL(string: stringURL) else { return }
        
        imageProvider.getImage(url: url) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    func loadFavorite(favorite: Favorite) {
        if let data = favorite.data {
            favoritesButton.isSelected = true
            imageView.image = UIImage(data: data)
            self.favorite = favorite
        }
    }
    
    @objc func showInfo() {
        guard let photo = photo else { return }
        let controller = UINavigationController(rootViewController: ImageInfoViewController(photo: photo))
        present(controller, animated: true, completion: nil)
    }
    
    @objc func saveDeleteFavorite(_ sender: UIButton) {
        if favorite != nil {
            deleteFavorite()
        } else {
            saveFavorite()
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    func saveFavorite() {
        if let id = photo?.id,
            let data = imageView.image?.pngData() {
            favorite = Favorite(id: id, data: data, context: dataController.viewContext)
        }
    }
    
    func deleteFavorite() {
        guard let favoriteImage = favorite else { return }
        dataController.viewContext.delete(favoriteImage)
        dataController.viewContext.saveChanges()
        self.favorite = nil
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
        guard let stringURL = photo?.links?.html,
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
