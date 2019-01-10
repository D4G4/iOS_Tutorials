//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Daksh Gargas on 08/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import UIKit

protocol ItemVCDelegate: class /*constraining it to be used only on classes*/ {
    func addItemVCDidCancel(_ controller: ItemDetailVC)
    func addItemVC(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem)
    func addItemVC(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem)
}

class ItemDetailVC: UITableViewController {

    weak var delegate: ItemVCDelegate?
    weak var todoList: TodoListModel?
    weak var itemToEdit: ChecklistItem?

    //MARK: Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.placeholder = item.text
            doneBarButton.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
        //textField.delegate = self  //or you can do it via interface builder
    }

    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }

    //MARK: Actions
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemVCDidCancel(self)
    }

    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            if let textFieldText = textField.text, !textFieldText.isEmpty {
                item.text = textFieldText
            }
            delegate?.addItemVC(self, didFinishEditing: item)
        } else {
            //let item = ChecklistItem(isChecked: false)
            if let item = todoList?.addRandomItem() {
                if let textFieldText = textField.text {
                    item.text = textFieldText
                }
                item.isChecked = false
                delegate?.addItemVC(self, didFinishAdding: item)
            }
        }
    }

    //MARK: Delegates (TableView)
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }


}

extension ItemDetailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //When user taps key on keyboard (you have control before it is actually displayed on the textField (like can manipulate what the user is typing))
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Range = \(range)")
        guard let oldText = textField.text,
            let oldStringRange = Range(range, in: oldText) else {
                return false
        }
        print("OldText = \(oldText)")
        print("string = \(string)")
        print("stringRange = \(oldStringRange)")
        let newText = oldText.replacingCharacters(in: oldStringRange, with: string)
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
