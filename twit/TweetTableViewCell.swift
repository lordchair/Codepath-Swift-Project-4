//
//  TweetTableViewCell.swift
//  twit
//
//  Created by Yale Thomas on 5/4/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var myTweet: Tweet?
    var myUser: User?
    
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTweet(twit: Tweet) {
        myTweet = twit
        if myTweet == nil {
            return
        }
        myUser = myTweet!.user
        if let profPicString: String? = myUser!.profileImageUrl {
            var profPicURL = NSURL(string: profPicString!)
            tweetImageView.setImageWithURL(profPicURL)
        }
        
        var userString = ""
        
        if var nameStr = myUser!.name as String? {
            userString += "\(nameStr)"
        }
        if var screenStr = myUser!.username as String? {
            userString += " - @\(screenStr)"
        }
        
        userLabel.text = "\(userString)"
        
        
        if var timeStr = myTweet!.createdAt?.dateTimeAgo() as String? {
            timeLabel.text = "\(timeStr)"
        }
        
        if var contStr = myTweet!.text as String? {
            contentLabel.text = contStr
        }
        
        
    }

}
