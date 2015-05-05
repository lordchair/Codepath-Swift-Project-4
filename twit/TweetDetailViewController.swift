//
//  TweetDetailViewController.swift
//  twit
//
//  Created by Yale Thomas on 5/5/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var myTweet: Tweet?
    var myUser: User?
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentView: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        setTweet(myTweet)
    }
    
    func setTweet(twit: Tweet?) {
        myTweet = twit
        if myTweet == nil {
            return
        }
        
        myUser = myTweet!.user
        if let profPicString: String? = myUser!.profileImageUrl {
            if var profPicURL = NSURL(string: profPicString!) {
                imageView.setImageWithURL(profPicURL)
            }
        }
        
        if var nameStr = myUser!.name as String? {
            nameLabel.text = "\(nameStr)"
        }
        
        if var screenStr = myUser!.username as String? {
            userLabel.text = "@\(screenStr)"
        }
        
        if var timeStr = myTweet!.createdAt?.timeAgo() as String? {
            timeLabel.text = "\(timeStr)"
        }
        
        if var contStr = myTweet!.text as String? {
            contentView.text = contStr
        }
        
        if var reStr = myTweet!.numRetweets as Int? {
            retweetLabel.text = "\(reStr) Retweets"
        }
        
        if var faStr = myTweet!.numFavorites as Int? {
            favoriteLabel.text = "\(faStr) Favorites"
        }
        
        if var isFav = myTweet!.isFavorited {
            if isFav {
                favoriteButton.setTitle("Unfavorite", forState: UIControlState.Normal)
            }
        }
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if var isFav = myTweet!.isFavorited {
            if isFav {
                TwitterClient.sharedInstance.unfavoriteTweet(myTweet!)
                myTweet!.numFavorites! -= 1
                if var faStr = myTweet!.numFavorites as Int? {
                    favoriteLabel.text = "\(faStr) Favorites"
                }
                favoriteButton.setTitle("Favorite", forState: UIControlState.Normal)
            } else {
                TwitterClient.sharedInstance.favoriteTweet(myTweet!)
                myTweet!.numFavorites! += 1
                if var faStr = myTweet!.numFavorites as Int? {
                    favoriteLabel.text = "\(faStr) Favorites"
                }
                favoriteButton.setTitle("Unfavorite", forState: UIControlState.Normal)
            }
            myTweet!.isFavorited = !isFav
        }

    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(myTweet!)
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "replySegue" {
            var destVC = segue.destinationViewController as! NewTweetViewController
            destVC.replyTweet = myTweet
            
            
        }
    }

}
