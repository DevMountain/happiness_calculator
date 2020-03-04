//
//  Entry.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 2/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation

/**
Creates our Entry Object - *MODEL*
 - Properties:
    - title: The `String` identifer for the `entry`
    - happiness: The `Int` value for how happy this `entry` makes you
    - isIncluded: The `Bool` to designiate whether the `entry` should be included in the average happiness rating
 */
class Entry {
    let title: String
    let happiness: Int
    var isIncluded: Bool
    
    init(title: String, happiness: Int, isIncluded: Bool) {
        self.title = title
        self.happiness = happiness
        self.isIncluded = isIncluded
    }
}
