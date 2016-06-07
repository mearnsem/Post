//
//  PostController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseUrl = NSURL(string: "https://devmtn-post.firebaseio.com/posts/")
    static let endpoint = baseUrl?.URLByAppendingPathExtension("json")

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
        
        guard let requestUrl = post.endpoint else { return }
        NetworkController.performRequestForURL(requestUrl, httpMethod: .Put, body: post.jsonData) { (data, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else {
                print("Successfully posted")
            }
        }
        fetchPosts()
    }
    
    func fetchPosts(completion: ((posts: [Post]) -> Void)? = nil) {
        guard let url = PostController.endpoint else {return}
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            guard let data = data,
            postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String: AnyObject]] else {
                if let completion = completion {
                    completion(posts: [])
                }
                return
            }
            
            let posts = postDictionaries.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            
            let sortedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})
            
            dispatch_async(dispatch_get_main_queue(), { 
                if let completion = completion {
                    completion(posts: posts)
                }
                self.posts = sortedPosts
                return
            })
           
        }
    }
}

protocol PostControllerDelegate: class {
    func postsUpdated(posts: [Post])
}