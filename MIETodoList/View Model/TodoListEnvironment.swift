//
//  TodoListEnvironment.swift
//  MIETodoList
//
//  Created by Brett Chapin on 11/5/23.
//

import SwiftUI
import SwiftData

@Observable
class TodoListEnvironment {
    /*
     TODO: - Create Environment Object to handle the following:
        0 - Connecting to the SwiftData Store
            - ModelContainer (the List of TodoTasks should be in the "main" vm)
        0 - To check if they have the Premium IAP
        0 - CRUD actions for the SwiftData Objects
        0 - Will handle how the app behaves (i.e. settings, trial, or premium)
        0 - First launch behavior
     */
    
    let context: ModelContext
    
    init() throws {
        // TODO: This needs updated once the behavior/IAP logic is implemented
        let modelContainer = try ModelContainer(for: TodoTask.self)
        context = .init(modelContainer)
    }
    
    // MARK: These functions handle the CRUD operations of SwiftData
    public func add(task: TodoTask) throws {
        context.insert(task)
        try context.save()
    }
    
    public func add(subtasks: [TodoTask], to parentTask: TodoTask) throws {
        subtasks.forEach { task in
            context.insert(task)
        }
        parentTask.add(subtasks)
        try context.save()
    }
    
    public func delete(task: TodoTask) throws {
        context.delete(task)
        try context.save()
    }
}
