//
//  NotFoundViewController.swift
//  iOS-assessment
//
//  Created by Mitali on 2025-05-01.
//

import UIKit

class NotFoundViewController: UIViewController {
    
    var username: String?
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // A closure to call when retrying the search
    var onRetry: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "User \"\(username ?? "")\" not found."
    }
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        // Call the onRetry closure to notify the parent view controller to try fetching the user again
        onRetry?()
    }
}
