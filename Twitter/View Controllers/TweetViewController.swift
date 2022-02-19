//
//  TweetViewController.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    
    var emptyTweetError: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.becomeFirstResponder()
        
        // Create new alert for loading of tweets error
        emptyTweetError = UIAlertController(title: "Alert", message: "Your tweet is empty.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        emptyTweetError.addAction(ok)

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    
    @IBAction func cancelTweet(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetText.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetText.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            // Print alert to enter some text
            self.present(self.emptyTweetError, animated: true, completion: nil)
        }
        
    }
    

}
