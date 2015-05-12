//
//  ContainerViewController.swift
//  twit
//
//  Created by Yale Thomas on 5/10/15.
//  Copyright (c) 2015 Yale Thomas. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var menuX: CGFloat!
    var menuY: CGFloat!
    var menuWidth: CGFloat!
    var collapsedMenuX: CGFloat!
    
    var containerX: CGFloat!
    var shiftContainerX: CGFloat!
    var containerY: CGFloat!
    
    let menuItems = [
        "Profile",
        "Mentions",
        "Timeline",
        "Logout"
    ]
    
    var contentController = UIStoryboard(
        name: "Main",
        bundle: NSBundle.mainBundle()
    ).instantiateViewControllerWithIdentifier("navCon") as! UINavigationController

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        contentController.view.frame = containerView.bounds
        containerView.addSubview(contentController.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenuTappedNotification", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        menuX = tableView.center.x
        menuY = tableView.center.y
        menuWidth = tableView.frame.size.width
        collapsedMenuX = tableView.center.x - menuWidth
        
        containerX = containerView.center.x
        containerY = containerView.center.y
        shiftContainerX = containerX + menuWidth
        
        containerView.center = CGPoint(x: containerX, y: containerY)
        tableView.center = CGPoint(x: collapsedMenuX, y: menuY)
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var velocity = sender.velocityInView(view).x
        
        if sender.state == UIGestureRecognizerState.Ended {
            if sender.velocityInView(view).x > 0 {
                tableView.center = CGPoint(x: menuX, y: menuY)
                containerView.center = CGPoint(x: shiftContainerX, y: containerY)
            } else {
                tableView.center = CGPoint(x: collapsedMenuX, y: menuY)
                containerView.center = CGPoint(x: containerX, y: containerY)
            }
        } else if sender.state == UIGestureRecognizerState.Changed {
            if collapsedMenuX + location.x < menuX {
                tableView.center = CGPoint(x: collapsedMenuX + location.x, y: menuY)
                containerView.center = CGPoint(x: containerX + location.x, y: containerY)
            } else {
                tableView.center = CGPoint(x: menuX, y: menuY)
                containerView.center = CGPoint(x: shiftContainerX, y: containerY)
            }
            
        }
        
    }
    
    func toggleMenu() {
        if tableView.center.x > collapsedMenuX {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.center = CGPoint(x: self.collapsedMenuX, y: self.menuY)
                self.containerView.center = CGPoint(x: self.containerX, y: self.containerY)
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.center = CGPoint(x: self.menuX, y: self.menuY)
                self.containerView.center = CGPoint(x: self.shiftContainerX, y: self.containerY)
            })
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let target = menuItems[indexPath.row]
        if target == "Profile" {
            let profileViewController = storyboard!.instantiateViewControllerWithIdentifier("profileViewCon") as! ProfileViewController
            profileViewController.myUser = User.currentUser
            contentController.showViewController(profileViewController, sender: self)
            toggleMenu()
        } else if target == "Timeline" {
            let tweetsViewController = storyboard!.instantiateViewControllerWithIdentifier("TweetsViewCon") as! TweetsViewController
            contentController.showViewController(tweetsViewController, sender: self)
            toggleMenu()
        } else if target == "Logout" {
            User.currentUser?.logout()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! MenuTableViewCell
        cell.titleLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
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
