//
//  TaskListVMTest.swift
//  ToDoListTests
//
//  Created by Admin on 9/2/24.
//

import XCTest
@testable import ToDoList
import Combine

final class TaskListVMTest: XCTestCase {
    private var viewModel: TaskListVM!
    private var mockApiService: MockApiService!
    private var mockCoreService: MockCoreService!
    private var cancellables = Set<AnyCancellable>()
    
    private var appearSubject: PassthroughSubject<Void, Error>!
    private var appearFromDatabaseSubject: PassthroughSubject<Void, Error>!
    
    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        mockCoreService = MockCoreService()
        viewModel = TaskListVM()
        viewModel.apiService = mockApiService
        viewModel.coreService = mockCoreService
        appearSubject = PassthroughSubject<Void, Error>()
        appearFromDatabaseSubject = PassthroughSubject<Void, Error>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockApiService = nil
        mockCoreService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testLoadDataSuccess() {
        MockApiService.shouldReturnError = false
        
        let input = TaskListVMInput(appear: appearSubject,
                                    appearFromDatabase: appearFromDatabaseSubject)
        
        let expectation = XCTestExpectation(description: "Loading data from API")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("Expected success, got \(error)")
            }
        }, receiveValue: { state in
            if case .tasks(let taskDTO) = state {
                XCTAssertEqual(taskDTO.todos.count, 1)
                XCTAssertEqual(taskDTO.todos.first?.todo, "Do something nice for someone you care about")
                expectation.fulfill()
            }
        }).store(in: &cancellables)
        
        if AppState.current.isFirstRun {
            appearSubject.send()
        } else {
            appearFromDatabaseSubject.send()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataFailure() {
        MockApiService.shouldReturnError = true
        
        let input = TaskListVMInput(appear: appearSubject,
                                    appearFromDatabase: appearFromDatabaseSubject)
        
        let expectation = XCTestExpectation(description: "Loading data from API")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTAssertEqual((error as NSError).domain, "TestError")
                expectation.fulfill()
            }
        }, receiveValue: { state in
            XCTFail("Expected failure, got \(state)")
        }).store(in: &cancellables)
        
        appearSubject.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataFromDatabaseSuccess() {
        let mockTask = ToDoList.Task(context: MockCoreDataStack.shared.context)
        mockTask.id = 1
        mockTask.title = "Test Task"
        mockTask.completed = false
        mockTask.dataOfCreation = Date()
        mockTask.taskDescription = "Description of Test Task"
        
        MockCoreService.fetchTasksCompletion = { [mockTask] in
            [mockTask]
        }
        
        let input = TaskListVMInput(appear: appearSubject,
                                    appearFromDatabase: appearFromDatabaseSubject)
        
        let expectation = XCTestExpectation(description: "Loading data from database")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("Expected success, got \(error)")
            }
        }, receiveValue: { state in
            if case .tasks(let taskDTO) = state {
                XCTAssertEqual(taskDTO.todos.count, 1)
                XCTAssertEqual(taskDTO.todos.first?.todo, "Test Task")
                expectation.fulfill()
            }
        }).store(in: &cancellables)
        
        appearFromDatabaseSubject.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataFromDatabaseFailure() {
        MockCoreService.fetchTasksCompletion = { nil }
        
        let input = TaskListVMInput(appear: appearSubject, appearFromDatabase: appearFromDatabaseSubject)
        
        let expectation = XCTestExpectation(description: "Loading data from database")
        viewModel.transform(input: input).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTAssertEqual((error as NSError).domain, "FetchError")
                expectation.fulfill()
            }
        }, receiveValue: { state in
            XCTFail("Expected failure, got \(state)")
        }).store(in: &cancellables)
        
        appearFromDatabaseSubject.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
