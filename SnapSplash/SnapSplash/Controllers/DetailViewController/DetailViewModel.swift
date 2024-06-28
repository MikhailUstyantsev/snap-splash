//
//  DetailViewModel.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 27.06.2024.
//

import Foundation
import Combine


final class DetailViewModel: NSObject {
    
    @Published var photoPublisher: Photo?
    
    func getPhoto(id photoID: String) {
        guard let url = Endpoint.getPhoto(matching: photoID).url else {
            return
        }
        Task {
            let photo = try? await NetworkManager.shared.retrievePhotosData(from: url)
            guard let photo else { return }
            photoPublisher = photo
        }
    }
}
