//
//  SSTabBarController.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 25.06.2024.
//

import UIKit


final class SSTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
        self.navigationController?.navigationBar.isHidden = true
        tabBar.tintColor = .systemPink
        delegate = self
    }
    
    
    private func createTabBar() {
        let searchViewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        let firstTab = UINavigationController(rootViewController: searchViewController)
        firstTab.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        let favoritesViewModel = FavoritesViewModel()
        let favoritesViewController = FavoritesViewController(viewModel: favoritesViewModel)
        let secondTab = UINavigationController(rootViewController: favoritesViewController)
        secondTab.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        
        viewControllers = [
            produceVC(
                viewController: firstTab,
                tabBarItemTitle: "Search",
                icon: UIImage(systemName: "magnifyingglass"),
                selectedIcon: nil
            ),
            produceVC(
                viewController: secondTab,
                tabBarItemTitle: "Favorites",
                icon: UIImage(systemName: "star"),
                selectedIcon: nil
            )
        ]
    }
    
    
    private func produceVC(viewController: UIViewController, tabBarItemTitle: String, icon: UIImage?, selectedIcon: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = tabBarItemTitle
        viewController.tabBarItem.image = icon
        viewController.tabBarItem.selectedImage = selectedIcon
        return viewController
    }
    
    
}


extension SSTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
