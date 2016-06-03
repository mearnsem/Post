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
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    var endpoint: NSURL? {
        return PostController.baseURL?.URLByAppendingPathComponent(self.identifier.UUIDString).URLByAppendingPathExtension(".json")
    }
    
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [keyUsername: self.username, keyText: self.text, keyTimestamp: self.timestamp]
        return json
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: NSJSONWritingOptions.PrettyPrinted)
    }
    
    var queryTimestamp: NSTimeInterval {
        return timestamp - 0.000001
    }
    
    init(username: String, text: String) {
        self.username = username
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970
        self.identifier = NSUUID()
    }
    
    init?(dictionary: [String: AnyObject], identifier: String?) {
        guard let username = dictionary[keyUsername] as? String,
            text = dictionary[keyText] as? String,
            timestamp = dictionary[keyTimestamp] as? NSTimeInterval,
            identifier = identifier,
            uniqueIdentifier = NSUUID(UUIDString: identifier) else {
            return nil
        }
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = uniqueIdentifier
    }
}

