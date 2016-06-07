//
//  PostListTableViewController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    var postController = PostController()
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        postController.delegate = self
    }
    
    @IBAction func refreshControlPull(sender: UIRefreshControl) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.fetchPosts { (posts) in
            sender.endRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        var userNameTextField = UITextField()
        var messageTextField = UITextField()
        let presentNewPostAlert = UIAlertController(title: "Post", message: "Write a message", preferredStyle: .Alert)
        
        presentNewPostAlert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "username"
            userNameTextField = textField
        }
        presentNewPostAlert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "message"
            messageTextField = textField
        }
        
        let postAction = UIAlertAction(title: "Post", style: .Default) { (_) in
            guard let userNameTextField = userNameTextField.text, messageTextField = messageTextField.text where userNameTextField.characters.count > 0 && messageTextField.characters.count > 0 else {
                self.presentErrorAlert()
                return
            }
            self.postController.addPost(userNameTextField, text: messageTextField)
        }
        presentNewPostAlert.addAction(postAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        presentNewPostAlert.addAction(cancelAction)
        
        tableView.reloadData()
        self.presentViewController(presentNewPostAlert, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let missingFieldsErrorAlert = UIAlertController(title: "Missing Info", message: "Please provide a username and a message", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        missingFieldsErrorAlert.addAction(okAction)
        self.presentViewController(missingFieldsErrorAlert, animated: true, completion: nil)
    }
    
    func postsUpdated(posts: [Post]) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        let date = NSDate(timeIntervalSince1970: post.timestamp)
        cell.detailTextLabel?.text = "\(post.username) - \(date.dateString())"
        
        return cell
    }
}