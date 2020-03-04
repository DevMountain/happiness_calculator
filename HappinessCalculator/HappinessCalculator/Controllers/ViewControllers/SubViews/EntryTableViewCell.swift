//
//  EntryTableViewCell.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 2/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit
/**
The protocol we will use to handle the updating of the cell when the `inEnabledSwitch` is toggled
   - class: This protocol can interact with class level objects

Delegate Methods:
   - switchToggled(on cell: EntryTableViewCell)

*/
protocol EntryCellDelegate: class {
    /// Declare the delegate method. I.E. What is the the task the delegate will need to perform
    func switchToggled(on cell: EntryTableViewCell)
}

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var higherOrLowerLabel: UILabel!
    @IBOutlet weak var isEnabledSwitch: UISwitch!
    
    // MARK: - Properties
    /**
    The delegate or *intern* for the `EntryCellDelegate` protocol

    - weak: We mark this method as weak to not create a retain cycle
    - optional: We do not want to set the value of the delegate here
    */
    weak var delegate: EntryCellDelegate?
    /// This entry will be passed to our `EntryTableViewCell` only once by our `EntryListTableViewController`. It will only be used in our `updateUI` function
    var entry: Entry?
    
    
    /// Updates the UIElements of our `EntryTableViewCell` based off of the `Entry`
    /// - Parameter averageHappiness: Used to determine if our cells `Entry` is higher or lower than the average happiness of all events
    func updateUI(averageHappiness: Int) {
        guard let entry = entry else {return}
        createObserver()
        titleLabel.text = entry.title
        isEnabledSwitch.isOn = entry.isIncluded
        higherOrLowerLabel.text = entry.happiness >= averageHappiness ? "Higher" : "Lower"
    }
    /**
     Creates the observer for notification key `notificationKey`, declared on entryTableViewController. We add a selector, which is basically telling our observer what function to call when it gets hit, to call `recalculateHappiness`.
     */
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.recalculateHappiness), name: Constants.notificationKey, object: nil)
    }
    
    @objc func recalculateHappiness(notification: NSNotification) {
        guard let averageHappiness = notification.object as? Int, let entry = entry else {return}
        higherOrLowerLabel.text = entry.happiness >= averageHappiness ? "Higher" : "Lower"
        
    }
    /// When our `isEnabledSwitch` is toggled it will tell our `delegate`, or intern, to go complete the task `switchToggled`
    @IBAction func isEnabledSwitchTapped(_ sender: UISwitch) {
        delegate?.switchToggled(on: self)
    }
}
