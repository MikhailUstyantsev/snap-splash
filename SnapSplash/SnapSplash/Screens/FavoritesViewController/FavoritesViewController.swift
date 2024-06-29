//
//  FavoritesViewController.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 25.06.2024.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Photo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Photo>
    
    let tableView = UITableView()
    let viewModel: FavoritesViewModel
    private lazy var tableDataSource = makeDataSource()
    var cancellables = Set<AnyCancellable>()
    
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        bind()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
    }
    
    
    private func configureViewController() {
        title = viewModel.title
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        view.addView(tableView)
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: String(describing: FavoriteCell.self))
        
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: margins.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    
    private func bind() {
        viewModel.persistenceResponse
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished: break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presentSSAlert(
                            title: "Something went wrong",
                            message: error.rawValue,
                            buttonTitle: "OK")
                    }
                }
            } receiveValue: { photos in
                self.applySnapshot(with: photos)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - DataSource methods
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, item) ->
                UITableViewCell? in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FavoriteCell.self),
                    for: indexPath) as? FavoriteCell
                cell?.set(favorite: item)
                return cell
            })
        return dataSource
    }
    
    
    private func applySnapshot(with items: [Photo], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        tableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}


extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = tableDataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewModel = DetailViewModel()
        detailViewModel.getPhoto(id: item.id)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = tableDataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            PersistenceManager.updateWith(photo: item, actionType: .remove) { [weak self] error in
                guard let self else { return }
                self.viewModel.getFavorites()
            }
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}
