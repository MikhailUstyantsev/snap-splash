//
//  NetworkManager.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 26.06.2024.
//

import Foundation


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func retrievePhotos(from url: URL) async throws -> Response {
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
    
    
    func retrievePhotosData(from url: URL) async throws -> Photo {
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(Photo.self, from: data)
    }
}
