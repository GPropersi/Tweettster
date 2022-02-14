//
//  TweetModel.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import Foundation


struct Tweet {
    var tweetText: String
    var userName: String
    var profileImageURLSecure: URL?
    
    init(tweetResponse: NSDictionary) {
        tweetText = tweetResponse["text"] as! String
        let userData = tweetResponse["user"] as! NSDictionary
        userName = userData["name"] as! String
        profileImageURLSecure = URL(string: userData["profile_image_url_https"] as! String)
    }
    
}
