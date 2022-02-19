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
    var retweeted: Bool
    var retweetCount: Int
    var favCount: Int
    var mediaURLHttps: String?
    
    init(tweetResponse: NSDictionary) {
        tweetText = tweetResponse["text"] as! String
        favorited = tweetResponse["favorited"] as! Bool
        let userData = tweetResponse["user"] as! NSDictionary
        userName = userData["name"] as! String
        tweetHandle = userData["screen_name"] as! String
        profileImageURLSecure = URL(string: userData["profile_image_url_https"] as! String)
        tweetID = tweetResponse["id"] as! Int
        retweeted = tweetResponse["retweeted"] as! Bool
        datePosted = tweetResponse["created_at"] as! String
        retweetCount = tweetResponse["retweet_count"] as! Int
        favCount = tweetResponse["favorite_count"] as! Int

        let entitiesObject = tweetResponse["entities"] as! NSDictionary
        
        let mediaObjectExists = entitiesObject["media"] != nil
        
        if mediaObjectExists {
            let mediaObject = entitiesObject["media"] as! [NSDictionary]
            
            let mediaURLExists = mediaObject[0]["media_url_https"] != nil
            
            if mediaURLExists {
                mediaURLHttps = (mediaObject[0]["media_url_https"] as? String) ?? ""
            } else {
                mediaURLHttps = ""
            }
            
        } else {
            mediaURLHttps = ""
        }
        
        timeSinceTweet = getTimeSincePosted()
        
    }
    
    func getStringofRetweetCounts() -> String {
        // Convert Retweet Count into string for insertion into label. Convert to #.#k format if number of retweets above 1000.
        if self.retweetCount > 999 {
            let thousandsRetweetCount = Int(self.retweetCount / 1000)
            
            return "\(thousandsRetweetCount)k"
        } else {
            return "\(self.retweetCount)"
        }
    }
    
    func getStringofFavCounts() -> String {
        // Convert Fav Count into string for insertion into label. Convert to #.#k format if number of faves above 1000.
        if self.favCount > 999 {
            let thousandsFavCount = Int(self.favCount / 1000)
            
            return "\(thousandsFavCount)k"
        } else {
            return "\(self.favCount)"
        }
    }
    
    func getTimeSincePosted() -> String {
        // Convert the string format "Wed May 23 06:01:13 +0000 2007" to a NSDateFormat. Find time since then.
        let fullTwitterTimeFormatter = DateFormatter()
        fullTwitterTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        fullTwitterTimeFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
        if let date = fullTwitterTimeFormatter.date(from: self.datePosted) {
            // Get time in seconds
            var timeInSec = Int(date.timeIntervalSinceNow) * -1
            
            if timeInSec > 59 {
                // At least a minute has passed
                var timeInMin = Int(timeInSec / 60)
                
                if timeInMin > 59 {
                    // At least 1 hr has passed
                    var timeInHrs = Int(timeInMin / 60)
                    
                    if timeInHrs > 23 {
                        // At least 1 day has passed
                        let timeInDays = lround(Double(timeInHrs / 24))
                        return "\(timeInDays)d"
                        
                    } else {
                        timeInHrs = lround(Double(timeInMin) / 60)
                        return "\(timeInHrs)h"
                    }
                    
                } else {
                    timeInMin = lround(Double(timeInSec) / 60)
                    return "\(timeInMin)m"
                }
                
            } else {
                timeInSec = lround(Double(timeInSec))
                return "\(timeInSec)s"
            }
        }
        return "0s"
    }
    
}
