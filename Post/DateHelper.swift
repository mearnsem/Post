//
//  DateHelper.swift
//  Post
//
//  Created by Emily Mearns on 6/7/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

extension NSDate {
    func dateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        return dateFormatter.stringFromDate(self)
    }
}