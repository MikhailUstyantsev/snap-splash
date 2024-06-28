//
//  DetailViewController.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 27.06.2024.
//

import UIKit
import Combine


final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
    }
    
    
    private func bind() {
        viewModel.$photoPublisher
            .sink { [weak self] photo in
                print(photo?.description)
            }
            .store(in: &cancellables)
    }

    
    
}
