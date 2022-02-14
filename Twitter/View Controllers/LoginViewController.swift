//
//  LoginViewController.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var loginError: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new alert for login error
        loginError = UIAlertController(title: "Alert", message: "Could not login.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        loginError.addAction(ok)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            // User logged in
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
        
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        let twitterOAuthURLPrefix = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: twitterOAuthURLPrefix, success: {
            // User success, store user and segue to home screen
            
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
            
        }, failure: { Error in
            // Failure in login
            self.present(self.loginError, animated: true, completion: nil)
        })
    }
}
