//
//  Endpoint.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 26.06.2024.
//

import Foundation


struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}


extension Endpoint {
    
    static func searchPhotos(matching query: String, page: Int = 1) -> Endpoint {
        return Endpoint(
            path: "/search/photos",
            queryItems: [
                URLQueryItem(name: "client_id", value: "QYSs8AxVUw0hDAbtb8J3yq3ze0zPS6Gm6Diyzwqd3wE"),
                URLQueryItem(name: "page", value: String(describing: page)),
                URLQueryItem(name: "per_page", value: "30"),
                URLQueryItem(name: "query", value: query)
            ]
        )
    }
    
}


extension Endpoint {
  
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
