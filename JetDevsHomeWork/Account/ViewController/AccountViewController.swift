//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLoginView()
    }
    
    // MARK: - Custom Methods
    
    /// Set View Based on login state
    fileprivate func setLoginView() {
       /// Get xAccToken from local if have and print
        if let xAcctoken: String = UserDefaultManager.shared.getString(forKey: xAccHeaderTokenStr) {
            debugPrint("xAcctoken: \(xAcctoken)")
        }
        
        /// Handle case like if User has already login Or Not
        if let user: User = UserDefaultManager.shared.getJson(forKey: loggedInUserStr) { // Already Login
            loginView.isHidden = false
            nonLoginView.isHidden = true
            
            let timeAgo = timeAgoString(from: user.createdAt)
            daysLabel.text = "Created \(timeAgo)"
            
            nameLabel.text = user.userName
            
            headImageView.kf.indicatorType = .activity
            headImageView.kf.setImage(with: URL(string: user.userProfileURL))
            
        } else { // Not login yet
            loginView.isHidden = true
            nonLoginView.isHidden = false
        }
    }
	
	@IBAction func loginButtonTap(_ sender: UIButton) {
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
}
