//
//  TaskListVC.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import UIKit
import Combine

final class TaskListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let appear = PassthroughSubject<Void, Error>()
    private var cancellables = Set<AnyCancellable>()
    var vm: TaskListVMType
    
    init(vm: TaskListVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if !AppState.current.isFirstRun {
            
            AppState.current.isFirstRun = true
        }
        bindViewModel()
        appear.send()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func bindViewModel() {
        let input = TaskListVMInput(appear: appear)
        let output = vm.transform(input: input)
        
        output.sink { _ in
        } receiveValue: { state in
            print(state.todos)
        }.store(in: &cancellables)
    }
}

extension TaskListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
