//
//  EntryListTableViewController.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 2/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

// MARK: - Notification Keys
//let notificationKey = Notification.Name(rawValue: "didChangeHappiness")

class EntryListTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var happinessLabel: UILabel!
    
    // MARK: - Properties
    var averageHappiness: Int = 0 {

         ///Everytime that we set out happiness level we post a notification that contains out notificationKey and our averageHappiness
        didSet {
            NotificationCenter.default.post(name: Constants.notificationKey, object: averageHappiness)
            happinessLabel.text = "Average Happiness: \(averageHappiness)"
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateHappiness()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///Casting our cell as a type EntryTableViewCell. If this fails then we just return a blank cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        
        ///grabbing the entry that we want
        let entry = EntryController.entries[indexPath.row]
        
        ///passing our entry to out function setEntry
        cell.entry = entry
        
        ///Updating the UI or our cell
        cell.updateUI(averageHappiness: averageHappiness)
        
        ///setting our cell's delegate equal to self. We can do this because of our EntryTableViewControllerProtocol Extension
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Update Happiness Function
    func updateHappiness() {
        var happinessTotal = 0
        //loops through all of our entries
        for entry in EntryController.entries {
            //If our entrys isIncluded is == true, then we add its happiness to happiness total
            if entry.isIncluded {
                happinessTotal += entry.happiness
            }
        }
        //calculates our average happienss. Using filter allows us to only divide by
        averageHappiness = happinessTotal / EntryController.entries.filter({$0.isIncluded}).count
    }
}

// MARK: - EntryTableViewCellProtocol Extension
    ///This extention inherits from EntryTableViewCellProtocol, which is declared on EntryTableViewCell, allowing us to get access to the tappedCell Function
extension EntryListTableViewController: EntryCellDelegate {
    func switchToggled(on cell: EntryTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let entry = EntryController.entries[indexPath.row]
        EntryController.updateEntry(entry: entry)
        updateHappiness()
    }
}
