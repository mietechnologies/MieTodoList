//
//  TodoTaskModelTests.swift
//  MIETodoListTests
//
//  Created by Brett Chapin on 10/8/23.
//

import XCTest
import SwiftData
import SwiftUI
@testable import MIETodoList

final class TodoTaskModelTests: XCTestCase {
    
    private var context: ModelContext!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let container = try ModelContainer(for: TodoTask.self, configurations: .init(isStoredInMemoryOnly: true))
        context = .init(container)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddTodoTask() throws {
        let newTask = TodoTask(name: "Finish Tests",
                               priority: .high,
                               description: "I need to finish these tests")
        context.insert(newTask)

        let tasks: [TodoTask] = try context.fetch(.init())

        XCTAssertEqual(tasks.count, 1)
        XCTAssertFalse(newTask.isComplete)
    }
    
    func testAddTodoTaskSubtasks() throws {
        let parentTask = TodoTask(name: "Finish Tests",
                                  priority: .high,
                                  description: "I need to finish these tests")
        let firstSubtask = TodoTask(name: "First Child Task",
                                    priority: .low,
                                    description: "This is the first subtask")
        let secondSubtask = TodoTask(name: "Second Child Task",
                                     priority: .none,
                                     description: "This is a second subtask")

        context.insert(firstSubtask)
        context.insert(secondSubtask)

        parentTask.add(firstSubtask)
        parentTask.add(secondSubtask)
        context.insert(parentTask)

        let tasks: [TodoTask] = try context.fetch(.init())

        XCTAssertEqual(tasks.count, 3)
        XCTAssertTrue(parentTask.hasUnfinishedSubtasks)
    }
    
    func testAddTodoTaskSubtasksArray() throws {
        let parentTask = TodoTask(name: "Finish Tests",
                                  priority: .high,
                                  description: "I need to finish these tests")
        let firstSubtask = TodoTask(name: "First Child Task",
                                    priority: .low,
                                    description: "This is the first subtask")
        let secondSubtask = TodoTask(name: "Second Child Task",
                                     priority: .none,
                                     description: "This is a second subtask")

        context.insert(firstSubtask)
        context.insert(secondSubtask)

        parentTask.add([firstSubtask, secondSubtask])
        context.insert(parentTask)

        let tasks: [TodoTask] = try context.fetch(.init())

        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual(parentTask.subtasks.count, 2)
        XCTAssertTrue(parentTask.hasUnfinishedSubtasks)
    }
    
    func testCompletedSubtasks() throws {
        let parentTask = TodoTask(name: "Finish Tests",
                                  priority: .high,
                                  description: "I need to finish these tests")
        let firstSubtask = TodoTask(name: "First Child Task",
                                    priority: .low,
                                    description: "This is the first subtask")
        let secondSubtask = TodoTask(name: "Second Child Task",
                                     priority: .none,
                                     description: "This is a second subtask")

        context.insert(firstSubtask)
        context.insert(secondSubtask)

        parentTask.add(firstSubtask)
        parentTask.add(secondSubtask)
        context.insert(parentTask)
        
        firstSubtask.complete()
        secondSubtask.complete()
        
        XCTAssertFalse(parentTask.hasUnfinishedSubtasks)
    }

}
