//
//  MealViewController.swift
//  MealApp
//
//  Created by Daksh Gargas on 29/12/18.
//  Copyright © 2018 Daksh Gargas. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate /* Let's ViewController take on some basic navigation responsibilities */ {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingConrol!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    /*
     This value is either passed by `MealTableViewController` via `prepare(for:sender:)`
     or constructed as part of adding a new meal.
            */
    var meal: Meal?

    // MARK: Navigation
    ///Whenever a segue gets triggered, it provides a place for you to add your own code that gets exeuted. This method gives you a chance to STORE DATA and do any necessary cleanup on the SOURCE VIEW CONTROLLER(the view controller that the segue is coming from)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // `===` identity operator -> to check the the objects REFERENCED by the `sender` and the `saveButton` outlset are the same
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating

        self.meal = Meal(name: name, photo: photo, rating: rating)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = self.presentingViewController is UINavigationController

        if isPresentingInAddMealMode {
              dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController /*If the view controller is pused onto a navigation stack*/{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewControlelr is not insdie a navigation controller.")
        }
    }

    //MARK: Actions
//    @IBAction func setDefaultLabelText(_ sender: UIButton) {
//        mealNameLabel.text = "Default Text"
//    }

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary

        imagePickerController.delegate = self

        // Method being called on ViewController. This method asks the ViewController to preent the view controller defined by imagePickerConroller.
        self.present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true //Yes, we want to process the press of the `Return`  key
    }

    //Gives you a chance to read the information entered into the text field and do something with it
    func textFieldDidEndEditing(_ textField: UITextField) {
        //mealNameLabel.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self

        if let meal = self.meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }

        updateSaveButtonState()
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    // MARK: Private Methods
    private func updateSaveButtonState() {
        //Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

