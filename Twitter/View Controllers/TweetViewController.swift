//
//  TweetViewController.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var tooManyCharsLabel: UILabel!
    
    var emptyTweetError: UIAlertController!
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.delegate = self
        
        tweetText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        tweetText.layer.borderWidth = 1.0
        tweetText.layer.cornerRadius = 5

        tweetText.becomeFirstResponder()
        
        // Create new alert for loading of tweets error
        emptyTweetError = UIAlertController(title: "Alert", message: "Your tweet is empty.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        emptyTweetError.addAction(ok)

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let charCount = 280 - tweetText.text.count
        characterCount.text = "\(charCount)"
        
        if charCount < 0 {
            tweetButton.isEnabled = false
            tooManyCharsLabel.text = "Too many characters."
        } else {
            tweetButton.isEnabled = true
            tooManyCharsLabel.text = ""
        }
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
