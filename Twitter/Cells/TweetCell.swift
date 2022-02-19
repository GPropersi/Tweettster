//
//  TweetCell.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    var tweetIDforCell: Int = -1
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var timeSinceTweeted: UILabel!
    @IBOutlet weak var tweetHandle: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!

// MARK: - Set the cell properties
    
    var tweetForCell: Tweet! {
        didSet {
            userNameLabel.text = tweetForCell.userName
            tweetContent.text = tweetForCell.tweetText
            timeSinceTweeted.text = tweetForCell.timeSinceTweet
            tweetHandle.text = "@" + tweetForCell.tweetHandle
            retweeted = tweetForCell.retweeted
            
            setFavorite(tweetForCell.favorited)
            setRetweeted(tweetForCell.retweeted)

            // Set Image
            profileImageView.af_setImage(withURL: tweetForCell.profileImageURLSecure!)
            
            // Set circular border
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
            
            tweetIDforCell = tweetForCell.tweetID
        }
    }
    
//MARK: - Set selected or retweeted and API calls for both functions
    
    var favorited: Bool = false
    var retweeted: Bool = false
    
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named:"favor-icon-red"), for:
                                UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named:"favor-icon"), for:
                                UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
// MARK: - IB Actions
    
    @IBAction func retweetPressed(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetID: self.tweetIDforCell, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Failure to retweet: \(error)")
        })
    }
    
    @IBAction func favPressed(_ sender: Any) {
        let toBeFavorited = !favorited
        
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetID: self.tweetIDforCell, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: self.tweetIDforCell, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
