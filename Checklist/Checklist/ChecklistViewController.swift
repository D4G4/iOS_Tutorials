//
//  ChecklistViewController.swift
//  Checklist
//
//  Created by Daksh Gargas on 07/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import UIKit

//class ChecklistViewController: UIViewController {
class ChecklistViewController: UITableViewController {
    typealias OptionalChecklist = [ChecklistItem?]

    var todoList: TodoListModel
    //var tableData: [OptionalChecklist?]! //Implicity unwrapped :: filled inside viewDidLoad()

    private func priorityForSectionIndex(_ index: Int) -> TodoListModel.Priority? {
        return TodoListModel.Priority(rawValue: index)
    }

    //@IBOutlet weak var tableView: UItableView

    //called when this VC is initialized from storyboard
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoListModel(numberOfIterations: 5)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true



//        let sectionTitleCount = UILocalizedIndexedCollation.current().sectionTitles.count //26
//        var allSections = [OptionalChecklist?](repeating: nil, count: sectionTitleCount) //26 individaul sections
//
//        var sectionNumber = 0
//        let collation = UILocalizedIndexedCollation.current()
//
//        for item in todoList.todos {
//            sectionNumber = collation.section(for: item, collationStringSelector: #selector(getter: ChecklistItem.text))
//            //(each section contains it's own array)
//            if allSections[sectionNumber] == nil {
//                allSections[sectionNumber] = [ChecklistItem?]()
//            }
//            allSections[sectionNumber]!.append(item) //-> Can be expanded as
////            var aSection: OptionalChecklist = allSections[sectionNumber]!
////            aSection.append(item)
////            allSections.append(aSection)
//        }
//        tableData = allSections
    }

    //MARK: Actions
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let newIndex = todoList.todoList(for: .medium).count
        _ = todoList.addRandomItem()

        let indexPath = IndexPath(row: newIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return ""
    }


    @IBAction func deleteItems(_ sender: Any) {
        if tableView.isEditing {
            if let selectedRows = tableView.indexPathsForSelectedRows {
                for indexPath in selectedRows {
                    if let priority = priorityForSectionIndex(indexPath.section) {
                        let todos = todoList.todoList(for: priority)

                        let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1: indexPath.row
                        let item = todos[rowToDelete]
                        todoList.remove(item: item, from: priority, at: rowToDelete)
                    }
                }
                tableView.beginUpdates()
                tableView.deleteRows(at: selectedRows, with: .automatic)
                tableView.endUpdates()
                // tableView.isEditing = false
            }
        } else {
            tableView.isEditing = true
            //self.editButtonItem.title = "Done"
            tableView.setEditing(true, animated: true)

        }
    }

    ///Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(item: item, from: priority, at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }

    ///When row is moved
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //  todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destinationPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destinationPriority, at: destinationIndexPath.row)
        }
        tableView.reloadData()
    }
//}

///Datasource
//extension ChecklistViewController: UITableViewDataSource {

    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        print("BeginEditing")
    }

    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("End editing")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
//}

///// User Interaction
//extension ChecklistViewController: UITableViewDelegate {
//
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { return }
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let items = todoList.todoList(for: priority)
                let item = items[indexPath.row]
                item.toggleChecked()
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.isChecked {
            checkmarkCell.checkmarkLabel.text = "✔"
        } else {
            checkmarkCell.checkmarkLabel.text = " "
        }
        // item.toggleChecked()
    }

    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.checkListLabel.text = item.text
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemVC = segue.destination as? ItemDetailVC {
                addItemVC.delegate = self
                addItemVC.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let addItemVC = segue.destination as? ItemDetailVC {
                addItemVC.delegate = self
                addItemVC.todoList = todoList
                if let cell = sender as? UITableViewCell,
                    let tappedIndexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(tappedIndexPath.section) {
                    let item = todoList.todoList(for: priority)[tappedIndexPath.row]
                    addItemVC.itemToEdit = item
                }
            }
        }
    }

    //MARK: Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoListModel.Priority.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority Todos"
            case .medium:
                title = "Medium Priority Todos"
            case .low:
                title = "Low Priority Todos"
            case .no:
                title = "No Priority Todos"
            }
        }
        return title

//        let val = UILocalizedIndexedCollation.current().sectionTitles[section]
//        print("titleForHeaderInSection \(val)")
//        return val
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
        return 0
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let val = UILocalizedIndexedCollation.current().sectionTitles
        print("sectionIndexTitles() -> \(val)")
        return val
    }

    ///Triggered when user taps the selection (right bar)
    ///TODO: If empty, next filled up item
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

        let val = UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
        print("sectionForSectionIndexTitle() -> \(val)")
        return val
    }
}

extension ChecklistViewController: ItemVCDelegate {
    func addItemVCDidCancel(_ controller: ItemDetailVC) {
        navigationController?.popViewController(animated: true)
    }

    func addItemVC(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem) {
         navigationController?.popViewController(animated: true)
//        tableView.beginUpdates()
//        todoList.addTodo(item, for: .medium)
        let newRowIndex = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: newRowIndex, section: TodoListModel.Priority.medium.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
        //tableView.endUpdates()
    }

    func addItemVC(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        for priority in TodoListModel.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.index(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
//        if let index = todoList.todos.index(of: item) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                configureText(for: cell, with: item)
//                navigationController?.popViewController(animated: true)
//            }
//        }
    }
}
