//
//  ChecklistViewController.swift
//  Checklist
//
//  Created by Daksh Gargas on 07/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController {
    
    var todoList: TodoListModel
    
    @IBOutlet weak var tableView: UITableView?

    //called when this VC is initialized from storyboard
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoListModel(numberOfIterations: 5)

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let newIndex = todoList.todos.count
        _ = todoList.addRandomItem()

        let indexPath = IndexPath(row: newIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView?.insertRows(at: indexPaths, with: .automatic)
    }
}

///Datasource
extension ChecklistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item: ChecklistItem = todoList.todos[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}

/// User Interaction
extension ChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCheckmark(for: cell, with: todoList.todos[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        cell.accessoryType = .none
        if item.isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        item.toggleChecked()
    }

    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
}
