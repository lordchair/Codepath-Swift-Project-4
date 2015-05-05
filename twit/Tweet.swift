//
//  Tweet.swift
//  twit
//
//  Created by Yale Thomas on 5/4/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var numRetweets: Int?
    var numFavorites: Int?
    var isFavorited: Bool?
    var id: Int?
   
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        id = dictionary["id"] as? Int
        isFavorited = dictionary["favorited"] as? Bool
        numFavorites = dictionary["favorite_count"] as? Int
        numRetweets = dictionary["retweet_count"] as? Int
        
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
