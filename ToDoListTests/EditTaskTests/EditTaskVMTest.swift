//
//  EditTaskTest.swift
//  ToDoListTests
//
//  Created by Admin on 9/2/24.
//

import XCTest
@testable import ToDoList
import Combine

final class EditTaskTest: XCTestCase {
    private var viewModel: EditTaskVM!
    private var mockCoreService: MockCoreService!
    private var cancellables = Set<AnyCancellable>()
    
    private var appearSubject: PassthroughSubject<Void, Error>!
    private var saveSubject: PassthroughSubject<TaskDTO.TaskInfo, Error>!
    private var deleteSubject: PassthroughSubject<Void, Error>!
    private var updateSubject: PassthroughSubject<UpdateTask, Error>!
    
    
    override func setUp() {
        super.setUp()
        mockCoreService = MockCoreService()
        viewModel = EditTaskVM(taskId: 1, state: .edit, coreService: mockCoreService, count: 1)
        
        appearSubject = PassthroughSubject<Void, Error>()
        saveSubject = PassthroughSubject<TaskDTO.TaskInfo, Error>()
        deleteSubject = PassthroughSubject<Void, Error>()
        updateSubject = PassthroughSubject<UpdateTask, Error>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testLoadTaskSuccess() {
        let taskToSave = TaskDTO.TaskInfo(id: 1, todo: "Test Task", completed: false, userId: 0, date: Date(), description: "Test Description")
        
        MockCoreService.tasksToReturn = [taskToSave]
        
        let input = EditTaskVMInput(appear: appearSubject,
                                    save: saveSubject,
                                    update: updateSubject,
                                    delete: deleteSubject)
        
        let expectation = XCTestExpectation(description: "Loading data from database")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("Expected success, got \(error)")
            }
        }, receiveValue: { state in
            if case .task(let task) = state {
                XCTAssertEqual(task.id, 1)
                XCTAssertEqual(task.title, "Test Task")
                expectation.fulfill()
            }
        }).store(in: &cancellables)
        
        appearSubject.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadTaskFailure() {
        MockCoreService.tasksToReturn = nil
        
        let input = EditTaskVMInput(appear: appearSubject,
                                    save: saveSubject,
                                    update: updateSubject,
                                    delete: deleteSubject)
        
        let expectation = XCTestExpectation(description: "Loading data from database")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTAssertEqual((error as NSError).domain, "FetchError")
                expectation.fulfill()
            }
        }, receiveValue: { state in
            XCTFail("Expected failure, got \(state)")
        }).store(in: &cancellables)
        
        appearSubject.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSaveTask() {
        let taskToSave = TaskDTO.TaskInfo(id: 1, todo: "New Task", completed: false, userId: 0, date: Date(), description: "New Description")
        
        MockCoreService.tasksToReturn = [taskToSave]
        
        let input = EditTaskVMInput(appear: appearSubject,
                                    save: saveSubject,
                                    update: updateSubject,
                                    delete: deleteSubject)
        
        let expectation = XCTestExpectation(description: "Saving task")
        
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("Expected success, got \(error)")
            }
        }, receiveValue: { state in
            if case .save = state {
                XCTAssertTrue(MockCoreService.isCalled[.saveTask] == true)
                XCTAssertTrue(((MockCoreService.tasksToReturn?.contains { savedTask in
                    savedTask.id == taskToSave.id &&
                    savedTask.todo == taskToSave.todo &&
                    savedTask.completed == taskToSave.completed &&
                    savedTask.userId == taskToSave.userId &&
                    savedTask.date == taskToSave.date &&
                    savedTask.description == taskToSave.description
                }) != nil))
                expectation.fulfill()
            }
        }).store(in: &cancellables)
        
        saveSubject.send(taskToSave)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteTask() {
        let input = EditTaskVMInput(appear: appearSubject,
                                    save: saveSubject,
                                    update: updateSubject,
                                    delete: deleteSubject)
        
        let expectation = XCTestExpectation(description: "Deleting task")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("Expected success, got \(error)")
            }
        }, receiveValue: { state in
            if case .delete = state {
                XCTAssertTrue(MockCoreService.isCalled[.deleteTask] == true)
                expectation.fulfill()
            }
        }).store(in: &cancellables)
        
        deleteSubject.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTask() {
        let updateTask = UpdateTask(title: "Updated Task",
                                    description: "Updated Description",
                                    completed: true)
        
        let existingTask = TaskDTO.TaskInfo(id: 1,
                                             todo: "Existing Task",
                                             completed: false,
                                             userId: 0,
                                             date: Date(),
                                             description: "Existing Description")
        
        MockCoreService.tasksToReturn = [existingTask]
        
        let input = EditTaskVMInput(appear: appearSubject,
                                    save: saveSubject,
                                    update: updateSubject,
                                    delete: deleteSubject)
        
        let expectation = XCTestExpectation(description: "Updating task")
        
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("Expected success, got \(error)")
            }
        }, receiveValue: { state in
            if case .update = state {
                XCTAssertTrue(MockCoreService.isCalled[.updateTask] == true)
                expectation.fulfill()
            }
        }).store(in: &cancellables)
        
        updateSubject.send(updateTask)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
