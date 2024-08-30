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
    private let appearFromDatabase = PassthroughSubject<Void, Error>()
    private var cancellables = Set<AnyCancellable>()
    var vm: TaskListVMType
    var sections: [Section] = []
    
    init(vm: TaskListVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        bindViewModel()
        if !AppState.current.isFirstRun {
            AppState.current.isFirstRun = true
            appear.send()
        } else {
            appearFromDatabase.send()
        }
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ofType: HeaderCell.self)
        tableView.registerCell(ofType: ExpandableCell.self)
    }
    
    private func bindViewModel() {
        let input = TaskListVMInput(appear: appear,
                                    appearFromDatabase: appearFromDatabase)
        let output = vm.transform(input: input)
        
        output.sink { _ in
        } receiveValue: { state in
            self.sections = state.todos.map {
                Section(mainCellTitle: .init(title: $0.todo, completable: $0.completed, date: $0.date), expandableCellOptions: $0.description, isExpandableCellsHidden: true)
            }
            self.updateTableView()
        }.store(in: &cancellables)
    }
    
    private func updateTableView() {
        tableView.reloadData()
    }
}

extension TaskListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if !section.isExpandableCellsHidden {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueCell(ofType: HeaderCell.self) else { return UITableViewCell() }
            let cellData = sections[indexPath.section].mainCellTitle
            cell.setup(title: cellData.title, completed: cellData.completable, date: cellData.date)
            return cell
        } else {
            guard let cell = tableView.dequeueCell(ofType: ExpandableCell.self) else { return UITableViewCell() }
            cell.setup(description: sections[indexPath.section].expandableCellOptions)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            let isHidden = sections[indexPath.section].isExpandableCellsHidden
            sections[indexPath.section].isExpandableCellsHidden.toggle()
            
            tableView.beginUpdates()
            
            if isHidden {
                tableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
            } else {
                tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
            }
            
            tableView.endUpdates()
        }
    }
}
