//
//  TodoList.swift
//  Checklist
//
//  Created by Daksh Gargas on 07/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import Foundation

class TodoListModel {

    typealias Checklist = [ChecklistItem]

    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }

    let tasks = ["Take a jog", "Watch a movie", "Code an app", "Walk the dog", "Study design patterns"]

    //var todos: [ChecklistItem] = []

    private var highPriorityTodos: Checklist = []
    private var mediumPriorityTodos: Checklist = []
    private var lowPriorityTodos: Checklist = []
    private var noPriorityTodos: Checklist = []

    init(numberOfIterations iterations: Int = 100) {
        for index in 0...iterations {
            //todos.append(ChecklistItem(text: tasks[index % 5]))
            let indBy5 = index % 5
            var priority: Priority!
            switch index {
            case _ where indBy5 == 0:
                priority = .high
            case _ where indBy5 == 1:
                priority = .low
            case _ where indBy5 == 2:
                priority = .no
            default:
                priority = .medium
            }
            addTodo(ChecklistItem(text: tasks[Int.random(in: 0..<tasks.count)]), for: priority)
        }
    }

    func todoList(for priority: Priority) -> Checklist {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos

        }
    }

    func addTodo(_ item: ChecklistItem, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
                mediumPriorityTodos.insert(item, at: index)
            }
        case .low:
            if index < 0 {
                lowPriorityTodos.append(item)
            } else {
                lowPriorityTodos.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noPriorityTodos.append(item)
            } else {
                noPriorityTodos.insert(item, at: index)
            }
        }
    }

    func addNewItem() -> ChecklistItem {
        let checklistItem = ChecklistItem(text: "Some default text")
        //todos.append(checklistItem)
        mediumPriorityTodos.append(checklistItem)
        return checklistItem
    }

    func addRandomItem() -> ChecklistItem {
        let text = tasks[Int.random(in: 0 ... tasks.count - 1)]
        let checklistItem = ChecklistItem(text: text)
        //todos.append(checklistItem)
        mediumPriorityTodos.append(checklistItem)
        return checklistItem
    }



    ///intra/inter-sections movement
    func move(item: ChecklistItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(item: item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)
    }

    func remove (item: ChecklistItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }

    func remove(items: Checklist) {
//        for item in items {
//            if let index = todos.lastIndex(of: item) {
//                todos.remove(at: index)
//            }
//        }
    }
}
