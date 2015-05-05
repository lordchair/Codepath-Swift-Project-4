//
//  NewTweetViewController.swift
//  twit
//
//  Created by Yale Thomas on 5/4/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    var myUser: User?
    
    var replyTweet: Tweet?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profView: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myUser == nil || myUser != User.currentUser {
            myUser = User.currentUser
        }
        if let profPicString: String? = myUser!.profileImageUrl {
            var profPicURL = NSURL(string: profPicString!)
            profView.setImageWithURL(profPicURL)
        }
        
        if var nameStr = myUser!.name as String? {
            nameLabel.text = "\(nameStr)"
        }
        
        if var screenStr = myUser!.username as String? {
            userLabel.text = "@\(screenStr)"
        }
        
        contentView.delegate = self
        contentView.text = ""
        if var aUser = replyTweet?.user!.username {
            contentView.text = "@\(aUser): "
        }
        contentView.becomeFirstResponder()
        
        
    }

    @IBAction func onSubmit(sender: AnyObject) {
        var strToSubmit = contentView.text
        if count(strToSubmit) > 140 || count(strToSubmit) == 0 {
            return
        }
        
        var params = ["status": strToSubmit]
        if replyTweet != nil {
            params["in_reply_to_status_id"] = "\(replyTweet!.id)"
        }
        TwitterClient.sharedInstance.composeTweet(params, completion: { (success) -> () in
            if success {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.contentView.text = "Error in Submitting Tweet"

            }
        })
    }
    
    func textViewDidChange(textView: UITextView) {
        updateCharsLeft()
    }
    
    func updateCharsLeft() {
        charsLeftLabel.text = String(140 - count(contentView.text))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
