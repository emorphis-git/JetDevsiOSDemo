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
        nonLoginView.isHidden = false
        loginView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
    }
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        let viewControllerInXib = LoginViewController(nibName: "LoginViewController", bundle: nil)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewControllerInXib, animated: true)
        } else {
            print("Navigation controller unavailable! Use present method.")
        }
    }
    
}

// MARK: - Supporting Function

extension AccountViewController {
    
    func setData() {
       
        self.tabBarController?.tabBar.isHidden = false
        if UserInfoModel.result == 1 {
            nonLoginView.isHidden = true
            loginView.isHidden = false
            nameLabel.text = UserInfoModel.data?.user.user_name
            let imageUrl = (UserInfoModel.data?.user.user_profile_url ?? "")
            if let url = URL(string: imageUrl) {
                let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
                headImageView.kf.setImage(with: resource, placeholder: UIImage(named: "Avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                headImageView.image = UIImage(named: "Avatar")
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let date = dateFormatter.date(from: UserInfoModel.data?.user.created_at ?? "") {
                let strDate = date.getElapsedInterval()
                daysLabel.text = MessageString.created + strDate
            } else {
                daysLabel.text = MessageString.created + (UserInfoModel.data?.user.created_at ?? "")
            }
        } else {
            nonLoginView.isHidden = false
            loginView.isHidden = true
        }
    }
}
