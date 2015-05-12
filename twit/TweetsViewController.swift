//
//  TweetsViewController.swift
//  twit
//
//  Created by Yale Thomas on 5/4/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        onRefresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        onRefresh()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets?.count {
            return count
        } else {
            return Int(0)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        
        var myTweet = tweets![indexPath.row] as Tweet
        
        cell.setTweet(myTweet)
        
        cell.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 99999)
        cell.contentView.bounds = cell.bounds
        cell.layoutIfNeeded()
        
        cell.userLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.userLabel.frame)
        cell.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.contentLabel.frame)
        
        return cell
    }
    
    func onRefresh() {
        TwitterClient.sharedInstance.getTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            print(self.tweets)
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        })
    }

    
    @IBAction func onProfilePressed(sender: AnyObject) {
        let cell = sender.superview?!.superview as! TweetTableViewCell
        self.performSegueWithIdentifier("profileSegue", sender: cell)
    }
    
    @IBAction func onMenuPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenuTappedNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destinationViewController as! TweetDetailViewController
            let cell = sender as! TweetTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let myTweet = tweets![indexPath!.row]
            
            detailVC.myTweet = myTweet
        }
        if segue.identifier == "profileSegue" {
            let detailVC = segue.destinationViewController as! ProfileViewController
            let cell = sender as! TweetTableViewCell
            
            detailVC.myUser = cell.myUser!
        }
    }

}
