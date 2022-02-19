//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Giovanni Propersi on 2/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    var tweetArray = [Tweet]()
    var numberOfTweets: Int!
    var tweetLoadError: UIAlertController!
    
    let tweetRefreshControl = UIRefreshControl()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Unhighlight selection between views
        self.clearsSelectionOnViewWillAppear = true
        
        // Create new alert for loading of tweets error
        tweetLoadError = UIAlertController(title: "Alert", message: "Could not login.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        tweetLoadError.addAction(ok)
        //tableView.separatorColor = UIColor.white // Implement for dark mode
        
        tweetRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    // MARK: - IB Actions
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Get initial Tweets onto the view
    
    @objc func loadTweets() {
        // Get tweets from API, load them into the cells
        numberOfTweets = 20
        
        let twitterTweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params: [String: Int] = ["count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterTweetURL, parameters: params, success:
            { (tweets: [NSDictionary]) in
            
            // Clear tweetArray, then add all tweets to it
            self.tweetArray.removeAll()
            for singleTweet in tweets {
                self.tweetArray.append(Tweet.init(tweetResponse: singleTweet))
            }
            
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not retrieve tweets.")
            self.present(self.tweetLoadError, animated: true, completion: nil)
        })
    }
    
    // MARK: - Add more tweets as user pulls from bottom
    
    func loadMoreTweets() {
        let twitterTweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        // Add 10 tweets to bottom of view
        numberOfTweets = numberOfTweets + 10
        let params: [String: Int] = ["count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterTweetURL, parameters: params, success:
            { (tweets: [NSDictionary]) in
            
            // Clear tweetArray, then add all tweets to it
            self.tweetArray.removeAll()
            for singleTweet in tweets {
                self.tweetArray.append(Tweet.init(tweetResponse: singleTweet))
            }
            
            self.tableView.reloadData()
            
        }, failure: { Error in
            print("Could not retrieve tweets.")
            self.present(self.tweetLoadError, animated: true, completion: nil)
        })
    }
    
    // Refreshes the tableview when user hits the bottom.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let tweet = tweetArray[indexPath.row]
        
        cell.tweetForCell = tweet
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}
