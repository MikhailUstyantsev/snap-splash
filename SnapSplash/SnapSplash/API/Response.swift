//
//  Response.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 26.06.2024.
//

import Foundation


struct Response: Codable, Hashable {
    let total, totalPages: Int
    let results: [Snap]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}


struct Snap: Codable, Hashable {
    let id: String?
    let createdAt: String?
    let description: String?
    let user: User?
    let urls: Urls?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case description
        case user
        case urls
    }
    
    static func == (lhs: Snap, rhs: Snap) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Urls: Codable, Hashable {
    let raw, full, regular, small: String?
    let thumb: String?
}


struct User: Codable, Hashable {
    let username, name: String?
}
