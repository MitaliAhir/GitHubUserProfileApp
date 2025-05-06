//
//  UserListViewController.swift
//  iOS-assessment
//
//  Created by Mitali on 2025-05-01.
//

import UIKit

class UserListViewController: UITableViewController {
    
    var username: String!
    var listType: ListType!
    var users: [GitHubUser] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Refresh control
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshUserList), for: .valueChanged)
            tableView.refreshControl = refreshControl
        title = listType == .followers ? "Followers" : "Following"
        fetchUserList()
    }
    
    @objc func refreshUserList() {
        fetchUserList()
        tableView.refreshControl?.endRefreshing()
    }
    func fetchUserList() {
           APIClient.shared.fetchUserList(for: username, listType: listType) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let users):
                       self?.users = users
                       self?.tableView.reloadData()
                   case .failure(let error):
                       print("Error fetching list: \(error.localizedDescription)")
                   }
               }
           }
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? TableViewCell else {
                return UITableViewCell()
            }
        
        let user = users[indexPath.row]
        cell.usernameLabel.text = user.username
        
        if let url = URL(string: user.avatarUrl) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, error == nil {
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()

        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedUser = users[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController {
                profileVC.user = selectedUser
                navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
