//
//  TodoList.swift
//  Checklist
//
//  Created by Daksh Gargas on 07/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import Foundation

class TodoListModel {
    let tasks = ["Take a jog", "Watch a movie", "Code an app", "Walk the dog", "Study design patterns"]
    var todos: [ChecklistItem] = []

    init(numberOfIterations iterations: Int = 100) {
        for index in 0...iterations {
            todos.append(ChecklistItem(text: tasks[index % 5]))
        }
    }

    func addNewItem() -> ChecklistItem {
        let checklistItem = ChecklistItem(text: "Some default text")
        todos.append(checklistItem)
        return checklistItem
    }
    
    func addRandomItem() -> ChecklistItem {
        let text = tasks[Int.random(in: 0 ... tasks.count - 1)]
        let checklistItem = ChecklistItem(text: text)
        todos.append(checklistItem)
        return checklistItem
    }
}
