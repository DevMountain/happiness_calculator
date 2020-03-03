
//
//  EntryController.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 2/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation

class EntryController {
    /**
    Source of Truth

    We created a computed property named `entries` and delcared the type to be an array of `Entry` objects

    - Returns: The mock `Entry` objects we created in an array
    */
    static var entries: [Entry] =  {
        var entry1 = Entry(title: "Reading", happiness: 7, isIncluded: true)
        var entry2 = Entry(title: "Riding my bike", happiness: 10, isIncluded: false)
        var entry3 = Entry(title: "Waking up", happiness: 1, isIncluded: true)
        var entry4 = Entry(title: "Reading documentation", happiness: 10, isIncluded: false)
        return [entry1, entry2, entry3, entry4]
    }()

    /**
     Updates the `entry` model object's `isIncluded` Bool to the opposite value
     - Parameters:
        - entry: The `Entry` object we want to update
     */
    static func updateEntry(entry: Entry) {
        entry.isIncluded = !entry.isIncluded
    }
}
