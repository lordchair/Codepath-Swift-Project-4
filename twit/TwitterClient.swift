//
//  TwitterClient.swift
//  twit
//
//  Created by Yale Thomas on 5/3/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

let twitterConsumerKey = "7GHPRGzu93nKxXd8dsH72elgo"
let twitterConsumerSecret = "lseKtOO9AhGqqc0AZwW8aVclWqQEQhSoitjblvYstCmMpC1t4i"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func getTimeLineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        getTimeLineWithParams(nil, completion: completion)
    }
    
    func getTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) -> () {
        println(params)
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            println("timeline success")
            completion(tweets: tweets, error: nil)
            
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("timeline error \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func composeTweet(params: NSDictionary, completion: (success: Bool) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //didTweet
            completion(success: true)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            //didn't tweet
            completion(success: false)
        }
    }
    
    func favoriteTweet(twit: Tweet) {
        var params = ["id": "\(twit.id)"]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //did favorite tweet
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                //didn't favorite tweet
        }
    }
    
    func unfavoriteTweet(twit: Tweet) {
        var params = ["id": "\(twit.id)"]
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //did unfavorite tweet
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                //didn't unfavorite tweet
        }
    }
    
    func retweet(twit: Tweet) {
        var params = ["id": "\(twit.id)"]
        POST("1.1/statuses/retweet/\(twit.id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //did retweet
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                //didn't retweet
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fetch request token and redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitDemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("got request token \(requestToken.token)")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                println("Failed to get request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("got user")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting user: \(error)")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                println("Oh god, no accessToken")
                
        }

    }
   
}
