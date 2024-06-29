//
//  SSError.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 29.06.2024.
//

import Foundation


enum SSError: String, Error {
    
    case unableToComplete = "Unable to connect your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "Data received from the server was invalid. Please try again"
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}
