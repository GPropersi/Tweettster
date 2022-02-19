//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/19/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {

    var accountInfo: NSDictionary!
    var loginError: UIAlertController!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var numbOfTweetsLabel: UILabel!
    @IBOutlet weak var numbOfFollowersLabel: UILabel!
    @IBOutlet weak var numbFollowingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new alert for login error
        loginError = UIAlertController(title: "Alert", message: "Could not login.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        loginError.addAction(ok)

        // Do any additional setup after loading the view.
        loadTweets()
    }
    

    // MARK: - Get Account Info loaded onto the view
    
    @objc func loadTweets() {
        // Get account info from API

        TwitterAPICaller.client?.getAccountInfo(success: { (accountInfo: NSDictionary) in
            self.accountInfo = accountInfo
            self.displayData()
            
        }, failure: { Error in
            self.present(self.loginError, animated: true, completion: nil)
        })
    }
    
    // MARK: - Display the account info data on the screen
    
    func displayData() {
        // Grab the output API account data and display it
        
        let backgroundImageSecureURL = URL(string: accountInfo["profile_background_image_url_https"] as! String)
        let profileImageSecureURL = URL(string: accountInfo["profile_image_url_https"] as! String)
        let screenName = accountInfo["screen_name"] as! String
        let numbOfTweets = accountInfo["statuses_count"] as! Int
        let followerCount = accountInfo["followers_count"] as! Int
        let followingCount = accountInfo["following"] as! Int
        let description = accountInfo["description"] as! String
        
        twitterHandle.text = "@" + screenName
        descriptionLabel.text = description
        numbOfTweetsLabel.text = "\(numbOfTweets)"
        numbOfFollowersLabel.text = "\(followerCount)"
        numbFollowingLabel.text = "\(followingCount)"
        
        backgroundImage.af_setImage(withURL: backgroundImageSecureURL!)
        profileImage.af_setImage(withURL: profileImageSecureURL!)
        
        // Set circular border
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }

}
