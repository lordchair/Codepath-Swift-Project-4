//
//  ProfileViewController.swift
//  twit
//
//  Created by Yale Thomas on 5/11/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var myUser: User?
    
    
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if myUser !== nil {
            updateData()
        }
    }
    
    @IBAction func onMenuPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenuTappedNotification", object: nil)
    }
    
    func updateData() {
        if let profPicString: String? = myUser!.profileImageUrl {
            let highResImageUrlString = profPicString!.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger", options: nil, range: nil)
            if let profPicURL = NSURL(string: highResImageUrlString) {
                profileImageView.setImageWithURL(profPicURL)
            }
        }
        if let bgPicString: String? = myUser!.profileBackgroundUrl {
            if let bgURL = NSURL(string: bgPicString!) {
                profileBackgroundImageView.setImageWithURL(bgURL)
            }
        }
        
        if var nameStr = myUser!.name as String? {
            nameLabel.text = "\(nameStr)"
        }
        
        if var screenStr = myUser!.username as String? {
            self.title = "@\(screenStr)"
        }
        
        if var numTweets = myUser!.numTweets as Int? {
            self.numTweets.text = "\(numTweets)"
        }
        
        if var numFollowing = myUser!.numFollowing as Int? {
            self.numFollowing.text = "\(numFollowing)"
        }
        
        if var numFollowers = myUser!.numFollowers as Int? {
            self.numFollowers.text = "\(numFollowers)"
        }


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
