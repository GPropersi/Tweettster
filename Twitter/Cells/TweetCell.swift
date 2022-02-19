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

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var timeSinceTweeted: UILabel!
    @IBOutlet weak var tweetHandle: UILabel!
    
    var tweetForCell: Tweet! {
        didSet {
            userNameLabel.text = tweetForCell.userName
            tweetContent.text = tweetForCell.tweetText
            timeSinceTweeted.text = tweetForCell.timeSinceTweet
            tweetHandle.text = "@" + tweetForCell.tweetHandle

            // Set Image
            profileImageView.af_setImage(withURL: tweetForCell.profileImageURLSecure!)
            profileImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
