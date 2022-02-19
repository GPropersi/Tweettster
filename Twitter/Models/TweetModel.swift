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
    var datePosted: String
    var timeSinceTweet: String!
    var tweetHandle: String
    var favorited: Bool
    var tweetID: Int
    
    init(tweetResponse: NSDictionary) {
        tweetText = tweetResponse["text"] as! String
        favorited = tweetResponse["favorited"] as! Bool
        let userData = tweetResponse["user"] as! NSDictionary
        userName = userData["name"] as! String
        tweetHandle = userData["screen_name"] as! String
        profileImageURLSecure = URL(string: userData["profile_image_url_https"] as! String)
        tweetID = tweetResponse["id"] as! Int
        datePosted = tweetResponse["created_at"] as! String
        
        
        timeSinceTweet = getTimeSincePosted()
    }
    
    func getTimeSincePosted() -> String {
        // Convert the string format "Wed May 23 06:01:13 +0000 2007" to a NSDateFormat. Find time since then.
        let fullTwitterTimeFormatter = DateFormatter()
        fullTwitterTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        fullTwitterTimeFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
        if let date = fullTwitterTimeFormatter.date(from: self.datePosted) {
            let timeInHrs = Int(date.timeIntervalSinceNow / 60) * -1
            
            if timeInHrs > 23 {
                let timeInDays = lround(Double(timeInHrs / 24))
                return "\(timeInDays)d"
            }
            else {
                return "\(timeInHrs)h"
            }
        }
        
        return "0h"
    }
    
}
