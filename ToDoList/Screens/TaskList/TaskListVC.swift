//
//  TaskListVC.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import UIKit
import Combine

struct Section {
    var mainCellTitle: MainCellData
    var expandableCellOptions: String
    var isExpandableCellsHidden: Bool
}

struct MainCellData {
    var title: String
    var completable: Bool
    var date: Date?
}

final class TaskListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let appear = PassthroughSubject<Void, Error>()
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
        if !AppState.current.isFirstRun {
            
            AppState.current.isFirstRun = true
        }
        bindViewModel()
        appear.send()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ofType: HeaderCell.self)
        tableView.registerCell(ofType: ExpandableCell.self)
    }
    
    private func bindViewModel() {
        let input = TaskListVMInput(appear: appear)
        let output = vm.transform(input: input)
        
        output.sink { _ in
        } receiveValue: { state in
            self.sections = state.todos.map {
                Section(mainCellTitle: .init(title: $0.todo, completable: $0.completed, date: $0.date), expandableCellOptions: $0.description ?? "", isExpandableCellsHidden: false)
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
            return section.expandableCellOptions.count + 1
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
            cell.setup(description: "dbsjhbcjkswfjnwnjf")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            sections[indexPath.section].isExpandableCellsHidden.toggle()
            tableView.reloadData()
        }

    }
}
