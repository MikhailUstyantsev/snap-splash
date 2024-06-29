//
//  DetailViewController.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 27.06.2024.
//

import UIKit
import Combine
import Kingfisher


final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let photoImageView = UIImageView()
    private let dimmedView = UIView()
    private let descriptionView = PhotoDescriptionView()
    var photo: Photo?
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        bind()
    }
    

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        addViews()
        configureViews()
        constraintViews()
    }
    
    
    private func bind() {
        viewModel.$photoPublisher
            .sink { [weak self] photo in
                guard let photo, let self else {
                    return
                }
                self.photo = photo
                self.setupDescriptionView(with: photo)
                
                guard let imageUrl = URL(string: photo.urls?.regular?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")  else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.photoImageView.kf.setImage(with: imageUrl) { result in
                        switch result {
                        case .success(_): break
                        case.failure(let error):
                            DispatchQueue.main.async {
                                self.presentSSAlert(
                                    title: "Error",
                                    message: "\(error.localizedDescription).😔",
                                    buttonTitle: "OK")
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }

    
    @objc private func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func addViews() {
        view.addView(photoImageView)
        photoImageView.addView(dimmedView)
        view.addView(descriptionView)
    }
    
    
    private func configureViews() {
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 50
        photoImageView.contentMode = .scaleAspectFill
        
        dimmedView.backgroundColor = .black.withAlphaComponent(0.15)
    }
    
    
    private func constraintViews() {
        let margins = view.safeAreaLayoutGuide
        dimmedView.pinToSuperviewEdges()
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5),
            photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5),
            photoImageView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.75),
            
            descriptionView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16),
            descriptionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5),
            descriptionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5),
            descriptionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -16),
        ])
    }
    
    
    
    
    @objc func addButtonTapped() {
        //MARK: Saving in persistence
        guard let photoToSave = photo else { return }
        addPhotoToFavorites(photoToSave)
    }
    
    
    func addPhotoToFavorites(_ photo: Photo) {
        let favoritePhoto = Photo(
            id: photo.id,
            createdAt: photo.createdAt,
            urls: photo.urls,
            user: photo.user,
            likes: photo.likes,
            downloads: photo.downloads,
            location: photo.location,
            description: photo.description
        )
        
        PersistenceManager.updateWith(photo: favoritePhoto, actionType: .add) { error in
            guard let error = error else {
                DispatchQueue.main.async {
                    self.presentSSAlert(
                        title: "Success!",
                        message: "You have successfully favorited this user 🎉",
                        buttonTitle: "Hooray!")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentSSAlert(
                    title: "Something went wrong",
                    message: error.rawValue,
                    buttonTitle: "Ok")
            }
        }
    }
    
    
    
}


extension DetailViewController {
    
    private func setupDescriptionView(with photo: Photo) {
        DispatchQueue.main.async {
            self.descriptionView.photoAuthorView
                .set(image: Constants.Image.personSquare,
                     message: photo.user?.name ?? "No author available"
                )
            self.descriptionView.creationDateView
                .set(image: Constants.Image.calendar,
                     message: photo.createdAt ?? "unknown"
                )
            self.descriptionView.locationView
                .set(image: Constants.Image.locationPin,
                     message: "\(photo.location?.name ?? "No location")"
                )
            self.descriptionView.downloadsView
                .set(image: Constants.Image.download,
                     message: "\(photo.downloads ?? 0)"
                )
        }
    }
    
}
