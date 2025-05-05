//
//  GitHubUser.swift
//  iOS-assessment
//
//  Created by Mitali on 2025-04-30.
//

import Foundation

// User Profile
struct GitHubUser: Decodable {
    let avatarUrl: String
    let username: String
    let name: String?
    let description: String?
    let followersCount: Int?
    let followingCount: Int?
    
    enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
            case username = "login"
            case name
            case description = "bio"
            case followersCount = "followers"
            case followingCount = "following"
        }
}
