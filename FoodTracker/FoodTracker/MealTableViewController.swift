//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Daksh Gargas on 26/12/18.
//  Copyright © 2018 Daksh Gargs. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {

    // MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        print("View Did Load")
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem

        //Load any saved meals, otherwie load sample data
        if let savedMeals = loadMeals() {
            print("Received data from loadMeals (idk how)")
            meals += savedMeals
        } else {
            print("Loading sample meals")
            loadSampleMeals()
        }

        // Uncomment the following line to preserve selection between presentations
        ///self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        /// self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("NumberOfSections")
        return 1
    }

    //Tells table how many rows to display in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView return meals.count")
        return meals.count
    }

    //Configures and provides cell to display for a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("return cell")
        let cellIdentifier = "MealTableViewCell"
        /* This identifier  (dequeueReusableCell) tells which type of cell it should create or reuse*/
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        let meal = meals[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }



    // Override to support conditional EDITING of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: OSLogType.debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("unexpected destination: \(segue.destination)")
            }

            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nil")")
            }

            guard let indexPath: IndexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("the selected cell is not being displayed by the table")
            }

            let selectedMeal: Meal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
        }
    }

    //  MARK: Actions
    //This method was initially called only when user taps the save button form MealViewController
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {

        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {

            //Checks whether a row in the table view is selected. If it is, that means that a user tapped one of the table view cells to edit a meal.
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)

                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            //save meal whenever a new one is added or an existing one is updated
            saveMeals()
        }//end of outer if statement
    }
    //  MARK: Private methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")

        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }

        meals += [meal1, meal2, meal3]
    }

    private func saveMeals() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        let isSuccessfulSave: Bool
        do {
            let data: NSData = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) as NSData
            isSuccessfulSave = data.write(toFile: Meal.ArchiveURL.path, atomically: true)
            if isSuccessfulSave {
                os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save meals...", log: OSLog.default, type: .error)
            }
        } catch {
            print("Some error")
        }
    
    }

    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
        
        //return NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data()
    }

}
