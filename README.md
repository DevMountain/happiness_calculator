# Average Happiness Simple
Average Happiness is a single view application that allows the user  to calculate their average happiness. Users can also toggle on and off which entries are included in the calculation.

## Part 1 - Custom Cell
Our custom cell with contain the UI elements of  our `UITableViewCell` and update the data within them

1. Create a new `Cocoa Touch Class` called `EntryTableViewCell`  that is a subclass of `UITableViewCell`
2. Delete all existing functions within our new cell class
3. Drag out outlets for all UI elements on our tableview cell
    * be sure to subclass our Cell as type `EntryTableViewCell`
```
@IBOutlet weak var titleLabel: UILabel!
@IBOutlet weak var higherorLowerLabel: UILabel!
@IBOutlet weak var isEnabledSwitch: UISwitch!
```

4. Create a variable called `entry` of an optional type `Entry`
`var entry: Entry?`

7. Create a function called `updateUI` that takes in an `Int`. This will update the UI Elements on our `UITableViewCell`. Note that we are not setting our `higherorLowerLabel` yet as we don’t  have a function to detect what it should be set too. We are building that next.
```
func updateUI(averageHappiness: Int) {
    guard let entry = entry else {return}
    titleLabel.text = “\(entry.title) -> \(entry.happiness)”
    isEnabledSwitch.isOn = entry.isIncluded
    higherorLowerLabel.text = entry.happiness >= averageHappiness ? “Higher” : “Lower”
}
```

## Part 2 - Creating our TableView
1. Create a new `Cocoa Touch Class`called `EntryListTableViewController`
    * be sure to subclass our TableView as type `EntryListTableViewController`
2. Remove all functions except
    * `ViewDidLoad`
    * `numberOfRowsInSection`
    * `cellForRowAt`
4. Create a variable called `averageHappiness` of type `Int`, give it a preset value of `0`
5. In our `numberOfRowsInSection` return `EntryController.entries.count`
6. In our `cellForRowAt` guard let our cell to be of type `EntryTableViewCell`
`guard let cell = tableView.dequeueReusableCell(withIdentifier: “EntryCell”, for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}`
7. Pass an entry to our cell then update the UI
```
///grabbing the entry that we want
let entry = EntryController.entries[indexPath.row]
///passing our entry to out function setEntry
cell.entry = entry
///Updating the UI or our cell
cell.updateUI(averageHappiness: averageHappiness)
```

## Part 3 - Protocols and Delegates
Explain Protocols and Delegates
Analogy that you can use
    * Intern
        * Has a list of stuff that the boss might want done and can tells the workers to do it
    * Boss
        * Tells his intern what he wants done and might give some information for the intern to pass on,  (ex: and Int of bool)
    * Worker
        * Is prepared to do anything the boss might want to do
        * Gets told by the intern when to  do a certain task
1. Back on our `EntryTableViewCell` declare a new protocol called `EntryCellDelegate` of type `class` above our `EntryTableViewCell` class
2. Inside our protocol declare a function called `switchToggled` that takes in a `EntrytableViewCell`
3. Inside our `EntryTableViewCell` class create a new property called `delegate` of type `EntryCellDelegate?`
4. Create an `IBAction`for the `UISwitch` with a sender of `UISwitch`
5. Inside the `UIAction` call our delegates `switchToggled` function passing in `self`
6. Back on our `EntryListTableViewController` create an extension of type `EntryCellDelegate` and conform to all protocols.
7. Inside of our newly made `switchToggled` function add a print statement for that says “switchToggled” for testing purposes
8. In our `CellForRowAt` add `cell.delegate = self` before we return the cell
9. Run the app and make sure that “switchToggled” is being printed
10. Create a new function in our `EntryListTableViewController` called `updateHappiness` that recalculates the average happiness
```
func updateHappiness() {
    var happinessTotal = 0
    //loops through all of our entries
    for entry in EntryController.entries {
        //If our entrys isIncluded is == true, then we add its happiness to happiness total
        if entry.isIncluded {
            happinessTotal += entry.happiness
        }
    }
    //calculates our average happienss
    averageHappiness = happinessTotal / EntryController.entries.filter({$0.isIncluded}).count
}
```

12. Back inside our `switchToggled` function we need to update our update our cells info and our average Happiness, run the app
```
guard let indexPath = tableView.indexPath(for: cell) else {return}
let entry = EntryController.entries[indexPath.row]
EntryController.updateEntry(entry: entry)
updateHappiness()
```

## Part 4 - Notifications and observers
Note: Explain Notifications and Observers, Analogy that you can use
    * Notifications are like a radio tower, and observers are like a radio, observers can only hear the station that they are tuned into

1. Create a new `.swift` file called `NotificationKeys` in our `Resources` folder
2. Inside of our `NotificationKeys` create a struct called `Constants` the contains a static property called `notificationKey`. Set it equal to `Notification.Name(rawValue: “didChangeHappiness”)`
3. On our `averageHappiness` add a didSet that septs our a notification every time we update the variable. For the object pass `averagehappiness`. Also set our title to the average happiness so we can see what it is in the application
```
var averageHappiness: Int = 0 {
    /*
     Everytime that we set out happiness level we post a notification that contains our notificationKey and our averageHappiness
     */
    didSet {
        NotificationCenter.default.post(name: Constants.notificationKey, object: averageHappiness)
        self.title = "Average Happiness: \(averageHappiness)"
    }
}
```

3. On our `EntryTableViewCell` create a function called `addObserver` that adds an observer listening for our `notificationKey`
```
func createObserver() {
    NotificationCenter.default.addObserver(self, selector:
#selector(self.recalcHappiness), name: Constants.notificationKey, object: nil)
}
```
5. Next add an objC function called `recalcHappiness` that  updates our cells average happiness label
```
@objc func recalcHappiness(notification: NSNotification) {
    guard let averageHappiness = notification.object as? Int, let entry = entry else {return}
      higherOrLowerLabel.text = entry.happiness >= averageHappiness ? “Higher” : “Lower”
}
```

