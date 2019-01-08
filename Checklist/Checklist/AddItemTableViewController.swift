//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Daksh Gargas on 08/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        //textField.delegate = self  //or you can do it via interface builder
    }

    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }

    //MARK: Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    //MARK: Actions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func done(_ sender: Any) {
        print("Contents of the text field \(textField.text ?? "nill")")
        navigationController?.popViewController(animated: true)
    }

    //MARK: Delegates (TableView)
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension AddItemTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //When user taps key on keyboard (you have control before it is actually displayed on the textField (like can manipulate what the user is typing))
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Range = \(range)")
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        print("OldText = \(oldText)")
        print("string = \(string)")
        print("stringRange = \(stringRange)")
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        print("New text = \(newText)")
        print("\n")
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true 
        }
        return true
    }
}
