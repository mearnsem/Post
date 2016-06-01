//
//  Post.swift
//  Post
//
//  Created by Emily Mearns on 6/1/16.
//  Copyright © 2016 Emily Mearns. All rights reserved.
//

import Foundation

struct Post {
    
    private let keyUsername = "username"
    private let keyText = "text"
    private let keyTimestamp = "timestamp"
    private let keyIdentifier = "identifier"
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval?
    let identifier: NSUUID?
    
    init(username: String, text: String, timestamp: NSTimeInterval? = NSDate().timeIntervalSince1970, identifier: NSUUID? = nil) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let username = dictionary[keyUsername] as? String, text = dictionary[keyText] as? String, timestamp = dictionary[keyTimestamp] as? NSTimeInterval, identifier = dictionary[keyIdentifier] as? NSUUID else {
            return nil
        }
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
}

