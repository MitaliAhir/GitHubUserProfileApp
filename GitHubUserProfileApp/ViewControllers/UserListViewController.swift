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
        title = listType == .followers ? "Followers" : "Following"
        fetchUserList()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            let user = users[indexPath.row]
            cell.textLabel?.text = user.username
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
