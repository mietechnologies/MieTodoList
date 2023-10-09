//
//  TodoTask.swift
//  MIETodoList
//
//  Created by Brett Chapin on 10/8/23.
//

import Foundation
import SwiftData

enum PriorityType: Int, Codable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
}

@Model
final class TodoTask {
    var name: String
    var priority: PriorityType
    var taskDescription: String
    var createdAt: Date
    var completedAt: Date?
    var isSubtask: Bool
    @Relationship(deleteRule: .cascade) var subtasks: [TodoTask] = []

    var isComplete: Bool {
        completedAt != nil
    }
    var hasUnfinishedSubtasks: Bool {
        if subtasks.isEmpty { return false }
        let incompleteTasks = subtasks.filter { !$0.isComplete }

        return !incompleteTasks.isEmpty
    }

    /// This initializer's default implementation is for new TodoTasks
    public init(name: String,
                priority: PriorityType,
                description: String,
                createdAt: Date = Date(),
                isSubtask: Bool = false,
                subtasks: [TodoTask] = []) {
        self.name = name
        self.priority = priority
        self.taskDescription = description
        self.createdAt = createdAt
        self.isSubtask = isSubtask
        self.subtasks = subtasks
    }

    /// A method for marking this TodoTask complete. It has a default value of false for if the TodoTask should be marked as complete for yesterday.
    /// (completedAt should never be set directly)
    public func complete(_ yesterday: Bool = false) { // TODO: Update it once Date has been updated with some convenience methods
        completedAt = yesterday ? Date() : Date()
    }

    /// A convenience method to add a subtask to this TodoTask.
    public func add(_ subtask: TodoTask) {
        let newTask = subtask
        newTask.isSubtask = true
        self.subtasks.append(newTask)
    }

    /// A convenience method to add multiple subtasks to this TodoTask. 
    /// This loops through the array of TodoTasks and runs the add(subtask:) method on them.
    public func add(_ subtaskGroup: [TodoTask]) {
        subtaskGroup.forEach { self.add($0) }
    }
}
