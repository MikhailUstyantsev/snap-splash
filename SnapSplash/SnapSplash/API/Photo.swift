//
//  Photo.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 28.06.2024.
//

import Foundation

struct Photo: Codable, Hashable {
    let id: String
    let createdAt: String?
    let urls: Urls?
    let user: User?
    let likes: Int?
    let downloads: Int?
    let location: Location?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case description = "alt_description"
        case user
        case likes
        case downloads
        case urls
        case location
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Location: Codable, Hashable {
    let name, city, country: String?
    let position: Position?
}


struct Position: Codable, Hashable {
    let latitude, longitude: Double?
}
