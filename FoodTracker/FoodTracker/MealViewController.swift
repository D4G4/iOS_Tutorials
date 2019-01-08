//  ViewController.swift
//  FoodTracker
//
//  Created by Daksh Gargas on 19/12/18.
//  Copyright © 2018 Daksh Gargas. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate /*,UIGestureRecognizerDelegate*/ {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        
        // Set up views if editing an existing meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        //Enable the save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        //not needed rn (can be deleted)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        //mealNameLabel.text = textField.text
    }
    
    //TODO: Work with it
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//    }

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("test",touch.location(in: self.view), separator: "", terminator: "\n")
//        if(photoImageView.bounds.contains(touch.location(in: photoImageView))) {
//            return true
//        }
//        else {
//            return false
//        }
//    }

    //MARK: Properties

    //Interface Builder, that's what `IB` in prefix stands for.
    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var mealNameLabel: UILabel!
//    @IBOutlet weak var defaultLabelText:  UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    /**
     This value is either passed by 'MealTableViewController' in 'prepare(for:sender:)' or constructed as part of adding a new meal
     */
    var meal: Meal?

    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        
        //  Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            //This method will work if the controller is presented MODALLY(the user tapped the Add button)
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            //This also means that the meal detail scene was pushed onto a navigation stack when the user selecteda meal from the meal list.
            //If it was presented with push navigateion(the user tapped a table view cell), it will be dismissed by the navigation controller that presented it
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewControlelr is not inside a navigation controller.")
        }
    }
    
  
// This method lets you configure a viewController (to be displayed) before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        print("MealViewController prepare()")
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name: String = nameTextField.text ?? ""
        let photo: UIImage? = photoImageView.image
        let rating: Int  = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions

//    @IBAction func setDefaultLabelText(_ sender: UIButton) {
//        mealNameLabel.text = "Dennis is a good Man"
//    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard

        nameTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick midea from their photo library.
        let imagePickerController = UIImagePickerController()

        //Only allow photos to be taken, not picked
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary

        imagePickerController.delegate = self

        // A method being called on ViewController. The method is executed on an implicit `self` object. The method asks ViewController to present the view controller defined by imagePickerController. Passing `true` to animated parameter animates the presentation of the image picker collection. The `completion` parameter refers to a completion handler, a piece of code the executes after this method completes. We are passing `nil` coz we don't need to do anything else.
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: UIImagePickerControllerDelegate functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //When user selects the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        // `as?` -> DOWNCASTING
        //It safely unwraps the optional returned by dictionary and cast it as a UIImage object. The exception is that the unwrapping and casting will never fail.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the follwing: \(info)")
        }

        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private methods
    private func updateSaveButtonState() {
        //Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
