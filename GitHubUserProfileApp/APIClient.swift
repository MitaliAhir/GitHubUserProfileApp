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
        print("Fetching URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(APIClientError.invalidData)) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network errors
            if let error = error {
                DispatchQueue.main.async { completion(.failure(APIClientError.networkError(error))) }
                return
            }
            
            // Check HTTP response status
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                DispatchQueue.main.async { completion(.failure(APIClientError.userNotFound)) }
                return
            }
            
            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(APIClientError.invalidData)) }
                return
            }
            
            // Decode JSON to GitHubUser
            do {
                let user = try JSONDecoder().decode(GitHubUser.self, from: data)
                DispatchQueue.main.async { completion(.success(user)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(APIClientError.decodingError(error))) }
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
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(APIClientError.invalidData)) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network errors
            if let error = error {
                DispatchQueue.main.async { completion(.failure(APIClientError.networkError(error))) }
                return
            }
            
            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(APIClientError.invalidData)) }
                return
            }
            
            // Decode JSON to list of GitHubUser
            do {
                let userList = try JSONDecoder().decode([GitHubUser].self, from: data)
                DispatchQueue.main.async { completion(.success(userList)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(APIClientError.decodingError(error))) }
            }
        }.resume()
    }
}
enum APIClientError: Error {
    case userNotFound
    case invalidData
    case networkError(Error)
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "The user could not be found."
        case .invalidData:
            return "The data received from the server was invalid."
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        }
    }
}

enum ListType {
    case followers, following
}
