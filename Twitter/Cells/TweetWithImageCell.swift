//
//  TweetWithImageCell.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/19/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetWithImageCell: UITableViewCell {
    // MARK: - This file contains a tweet cell WITH an image.
    
    var tweetIDforCell: Int = -1
    var favorited: Bool!
    var retweeted: Bool!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var timeSinceTweeted: UILabel!
    @IBOutlet weak var tweetHandle: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCounts: UILabel!
    @IBOutlet weak var favCounts: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    
// MARK: - Set the cell properties
    
    var tweetForCell: Tweet! {
        didSet {
            mediaImage.isHidden = true
            
            userNameLabel.text = tweetForCell.userName
            tweetContent.text = tweetForCell.tweetText
            timeSinceTweeted.text = tweetForCell.timeSinceTweet
            tweetHandle.text = "@" + tweetForCell.tweetHandle

            retweetCounts.text = tweetForCell.getStringofRetweetCounts()
            favCounts.text = tweetForCell.getStringofFavCounts()

            // Set Image
            profileImageView.af_setImage(withURL: tweetForCell.profileImageURLSecure!)
            
            // Set circular border
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
            
            tweetIDforCell = tweetForCell.tweetID

            if tweetForCell.mediaURLHttps != "" {
                // Set Image
                mediaImage.isHidden = false
                let mediaImageURL = URL(string: tweetForCell.mediaURLHttps!)
                mediaImage.af_setImage(withURL: mediaImageURL!)
                mediaImage.clipsToBounds = true
            }
        }
    }
    
    //MARK: - Set selected or retweeted and API calls for both functions
        
        func setFavorite(_ isFavorited: Bool) {
            self.favorited = isFavorited
            if (isFavorited) {
                favButton.setImage(UIImage(named:"favor-icon-red"), for:
                                    UIControl.State.normal)
            }
            else {
                favButton.setImage(UIImage(named:"favor-icon"), for:
                                    UIControl.State.normal)
            }
        }
        
        func setRetweeted(_ isRetweeted: Bool) {
            self.retweeted = isRetweeted
            if (isRetweeted) {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            }
        }
        
    
    // MARK: - IB Actions
        
        @IBAction func retweetPressed(_ sender: Any) {
            self.retweeted = !self.retweeted
            
            if (self.retweeted) {
                TwitterAPICaller.client?.retweet(tweetID: self.tweetIDforCell, success: {
                    self.tweetForCell.retweetCount += 1
                    self.retweetCounts.text = self.tweetForCell.getStringofRetweetCounts()
                    self.setRetweeted(true)
                }, failure: { (error) in
                    print("Failure to retweet: \(error)")
                })
            } else {
                TwitterAPICaller.client?.unretweet(tweetID: self.tweetIDforCell, success: {
                    self.tweetForCell.retweetCount -= 1
                    self.retweetCounts.text = self.tweetForCell.getStringofRetweetCounts()
                    self.setRetweeted(false)
                }, failure: { (error) in
                    print("Failure to remove retweet: \(error)")
                })
            }
        }
        
        @IBAction func favPressed(_ sender: Any) {
            self.favorited = !self.favorited
            
            if (self.favorited) {
                TwitterAPICaller.client?.favoriteTweet(tweetID: self.tweetIDforCell, success: {
                    self.tweetForCell.favCount += 1
                    self.favCounts.text = self.tweetForCell.getStringofFavCounts()
                    self.setFavorite(true)
                }, failure: { (error) in
                    print("Favorite did not succeed: \(error)")
                })
            } else {
                TwitterAPICaller.client?.unfavoriteTweet(tweetID: self.tweetIDforCell, success: {
                    self.tweetForCell.favCount -= 1
                    self.favCounts.text = self.tweetForCell.getStringofFavCounts()
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
