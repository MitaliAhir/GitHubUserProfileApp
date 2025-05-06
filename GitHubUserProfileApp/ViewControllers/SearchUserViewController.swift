//
//  SearchUserViewController.swift
//  iOS-assessment
//
//  Created by Mitali on 2025-04-30.
//

import UIKit

class SearchUserViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    // When user presses the return key on the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let username = searchBar.text, !username.isEmpty else { return }
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        // Show loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        APIClient.shared.fetchUser(username: username) { [weak self] result in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                // Remove activity indicator
                self?.navigationItem.rightBarButtonItem = nil
                switch result {
                case .success(let user):
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController {
                        profileVC.user = user
                        self?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                case .failure(let error):
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let apiError = error as? APIClientError, case .userNotFound = apiError {
                        if let notFoundVC = storyboard.instantiateViewController(withIdentifier: "NotFoundVC") as? NotFoundViewController {
                            notFoundVC.username = username
                            // Set the retry closure to trigger a new search.
                            notFoundVC.onRetry = { [weak self] in
                                self?.searchBarSearchButtonClicked(searchBar)
                            }
                            self?.navigationController?.pushViewController(notFoundVC, animated: true)
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

