//
//  APIClient.swift
//  iOS-assessment
//
//  Created by Mitali on 2025-05-01.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private init() { }
        
        // Fetch a GitHub user by username
        func fetchUser(username: String, completion: @escaping (Result<GitHubUser, Error>) -> Void) {
            let urlString = "https://api.github.com/users/\(username)"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                // Error handling: Network error or missing data
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                // Check HTTP response
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 404 {
                    let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                    DispatchQueue.main.async { completion(.failure(notFoundError)) }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(NSError(domain: "", code: -1, userInfo: nil))) }
                    return
                }
                // Decode JSON to GitHubUser
                do {
                    let user = try JSONDecoder().decode(GitHubUser.self, from: data)
                    DispatchQueue.main.async { completion(.success(user)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        }
        
        // Fetch followers or following list
        func fetchUserList(for username: String, listType: ListType, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
            let endpoint: String
            switch listType {
            case .followers:
                endpoint = "followers"
            case .following:
                endpoint = "following"
            }
            let urlString = "https://api.github.com/users/\(username)/\(endpoint)"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                // Error handling
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(NSError(domain: "", code: -1, userInfo: nil))) }
                    return
                }
                do {
                    let userList = try JSONDecoder().decode([GitHubUser].self, from: data)
                    DispatchQueue.main.async { completion(.success(userList)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        }
    }

    enum ListType {
        case followers, following
    }
