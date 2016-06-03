//
//  PostController.swift
//  Post
//
//  Created by Emily Mearns on 6/1/16.
//  Copyright © 2016 Emily Mearns. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com")
    static let endpoint = baseURL?.URLByAppendingPathComponent("/posts.json")
    
    weak var delegate = PostControllerDelegate?()
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    init() {
        fetchPosts()
    }
    
    func addPost(username: String, text: String) {
        let post = Post(username: username, text: text)
        guard let requestUrl = post.endpoint else { fatalError("URL optional is nil") }
        
        NetworkController.performRequestForUrl(requestUrl, httpmethod: .Put, body: post.jsonData) { (data, error) in
            <#code#>
        }
    }
    
    func fetchPosts(completion: ((posts: [Post]) -> Void)? = nil) {
        
        guard let url = PostController.endpoint else { fatalError("URL optional is nil") }
        
        NetworkController.performRequestForUrl(url, httpmethod: .Get) { (data, error) in
            guard let data = data, postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String:AnyObject]] else {
                if let completion = completion {
                    completion(posts: [])
                }
                return
            }
            
            let posts = postDictionaries.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            
            let sortedPosts = posts.sort({$0.timestamp > $1.timestamp})
            
            self.posts = sortedPosts
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let completion = completion {
                    completion(posts: sortedPosts)
                }
            })

        }
    }
}

protocol PostControllerDelegate: class {
    func postsUpdated(posts: [Post])
}