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
    
    var posts: [Post] = []
    
    static func fetchPosts(completion: ((posts: [Post]) -> Void)? = nil) {
        guard let url = self.baseURL else { fatalError("URL optional is nil") }
        
        NetworkController.performRequestForUrl(url, httpmethod: .Get, urlParameters: nil, body: nil) { (data, error) in
            guard let data = data, postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String:AnyObject]] else {
                if let completion = completion {
                    completion(posts: [])
                }
                return
            }
            let posts = postDictionaries.flatMap({Post(dictionary: $0.1)})
            if let completion = completion {
                completion(posts: posts)
            }
            
        }
    }
}