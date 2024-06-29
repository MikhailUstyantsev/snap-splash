//
//  FavoritesViewModel.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 29.06.2024.
//

import Foundation
import Combine

final class FavoritesViewModel: NSObject {
    
    var persistenceResponse = CurrentValueSubject<[Photo], SSError>([])
    let title = Constants.String.favorites
    
    func  getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let favorites):
                self.persistenceResponse.value = favorites
            case .failure(let error):
                self.persistenceResponse.send(completion: .failure(error))
            }
        }
    }
}
