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
        tableView.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        
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
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        missingFieldsErrorAlert.addAction(okAction)
        self.presentViewController(missingFieldsErrorAlert, animated: true, completion: nil)
    }
    
    func postsUpdated(posts: [Post]) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row + 1 == postController.posts.count {
            postController.fetchPosts(false, completion: { (posts) in
                if !posts.isEmpty {
                    tableView.reloadData()
                }
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.textLabel?.textColor = .whiteColor()
        
        let date = NSDate(timeIntervalSince1970: post.timestamp)
        cell.detailTextLabel?.text = "\(post.username) - \(date.dateString())"
        cell.detailTextLabel?.textColor = .whiteColor()
        
        return cell
    }
}