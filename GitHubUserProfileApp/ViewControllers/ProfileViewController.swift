//
//  ProfileViewController.swift
//  iOS-assessment
//
//  Created by Mitali on 2025-05-01.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: GitHubUser!
    
    // UI Elements
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }
    
    private func configureUI() {
        usernameLabel.text = user.username
        nameLabel.text = user.name ?? "No name available"
        descriptionLabel.text = user.description ?? "No bio available"
        
        // Use 0 as default if counts are missing
        let followers = user.followersCount ?? 0
        let following = user.followingCount ?? 0
        followersButton.setTitle("\(followers) followers", for: .normal)
        followingButton.setTitle("\(following) following", for: .normal)
        
        if let url = URL(string: user.avatarUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        followersButton.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(showFollowing), for: .touchUpInside)
    }


        
        @objc func showFollowers() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let listVC = storyboard.instantiateViewController(withIdentifier: "UserListVC") as? UserListViewController {
                listVC.username = user.username
                listVC.listType = .followers
                navigationController?.pushViewController(listVC, animated: true)
            }
        }
        
        @objc func showFollowing() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let listVC = storyboard.instantiateViewController(withIdentifier: "UserListVC") as? UserListViewController {
                listVC.username = user.username
                listVC.listType = .following
                navigationController?.pushViewController(listVC, animated: true)
            }
        }
    }
