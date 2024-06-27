//
//  SearchViewController.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 25.06.2024.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {

    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Result>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Result>
    
    
    //MARK: - Properties
    private let viewModel: SearchViewModel
    private let searchController = UISearchController()
    private var cancellables = Set<AnyCancellable>()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: generateLayout())
        return collection
    }()
    private lazy var collectionDataSource = makeDataSource()
    
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        requestData()
        bind()
    }
    

    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = viewModel
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    
    private func configureCollectionView() {
        view.addView(collectionView)
        collectionView.register(
            PicGridCell.self,
            forCellWithReuseIdentifier: String(describing: PicGridCell.self))
        collectionView.delegate = self
        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    
    private func requestData() {
        viewModel.getPhotos(matching: Constants.String.random)
    }
    
    
    private func bind() {
        viewModel.apiResponse
            .sink { [weak self] result in
                guard let self else { return }
                self.applySnapshot(with: result)
            }
            .store(in: &cancellables)
    }
    
    
    private func generateLayout() -> UICollectionViewLayout {
        let inset: CGFloat = 2.5
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    // MARK: - DataSource methods
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: PicGridCell.self),
                    for: indexPath) as? PicGridCell
                cell?.picItem = item
                return cell
            })
        return dataSource
    }
    
    
    private func applySnapshot(with items: [Result], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        collectionDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}


extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = collectionDataSource.itemIdentifier(for: indexPath) else { return }
        print(item.user?.name)
    }
}
