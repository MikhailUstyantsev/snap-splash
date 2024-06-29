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
        addTarget()
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
    
    
    
    
    private func addTarget() {
       //for saving in persistence
    }
    
}


extension DetailViewController {
    
    private func setupDescriptionView(with photo: Photo) {
        DispatchQueue.main.async {
            self.descriptionView.photoAuthorView
                .set(image: Constants.Image.personSquare,
                     message: photo.user?.name ?? "unknown"
                )
            self.descriptionView.creationDateView
                .set(image: Constants.Image.calendar,
                     message: photo.createdAt ?? "unknown"
                )
            self.descriptionView.locationView
                .set(image: Constants.Image.locationPin,
                     message: "\(photo.location?.name ?? "unknown")"
                )
            self.descriptionView.downloadsView
                .set(image: Constants.Image.download,
                     message: "\(photo.downloads ?? 0)"
                )
        }
    }
    
}
