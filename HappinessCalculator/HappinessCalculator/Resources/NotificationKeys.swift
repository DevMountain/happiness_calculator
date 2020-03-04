//
//  NotificationKeys.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 3/3/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation


/// This will allow us to use the same notification key all throughout our application without having to worry about miss types. Also if we ever wanted to change the key we can do that here instead of every place we use it.
struct Constants {
    static let notificationKey = Notification.Name(rawValue: "didChangeHappiness")
}

