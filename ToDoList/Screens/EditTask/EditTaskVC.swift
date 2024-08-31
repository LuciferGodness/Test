//
//  EditTaskVC.swift
//  ToDoList
//
//  Created by Admin on 8/31/24.
//

import UIKit
import Combine

final class EditTaskVC: BaseVC {
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextView!
    @IBOutlet private weak var checkbox: UIButton!
    @IBOutlet private weak var saveBtn: UIButton!
    var vm: EditTaskVMType
    private let appear = PassthroughSubject<Void, Error>()
    private let save = PassthroughSubject<TaskDTO.TaskInfo, Error>()
    private let update = PassthroughSubject<UpdateTask, Error>()
    private let delete = PassthroughSubject<Void, Error>()
    private var cancellables = Set<AnyCancellable>()
    private var completed: Bool = false
    private let clearImage = UIImage()
    
    init(vm: EditTaskVMType) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        bindViewModel()
        appear.send()
        super.viewDidLoad()
        checkbox.layer.borderColor = AppColors.gray
        checkbox.layer.borderWidth = 2
        checkbox.layer.cornerRadius = 6
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 10
        descriptionTextField.layer.borderColor = AppColors.lightGray
        descriptionTextField.addDismissKeyboardGesture()
        titleTextField.delegate = self
    }
    
    private func bindViewModel() {
        let input = EditTaskVMInput(appear: appear,
                                    save: save,
                                    update: update,
                                    delete: delete)
        let output = vm.transform(input: input)
        
        output.sink { _ in
        } receiveValue: { state in
            self.updateView(state: state)
        }.store(in: &cancellables)
    }
    
    private func updateView(state: EditTaskResponseType) {
        switch state {
        case .task(let task):
            self.titleTextField.text = task.title
            self.descriptionTextField.text = task.taskDescription
            self.completed = task.completed
            self.updateImage()
        case .save, .update, .delete:
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            print(error)
        }
    }
    
    @IBAction private func updateStatus() {
        completed.toggle()
        updateImage()
    }
    
    @IBAction private func saveData() {
        if vm.state == .create {
            if let title = titleTextField.text {
                save.send(.init(id: vm.count,
                                todo: title,
                                completed: completed,
                                userId: 1,
                                date: .now,
                                description: descriptionTextField.text))
            } else {
                showAlert(message: "Please fill title", nil, title: "Error", okTitle: "Ok")
            }
        } else {
            if let title = titleTextField.text {
                update.send(.init(title: title, description: descriptionTextField.text, completed: completed))
            } else {
                showAlert(message: "Please fill title", nil, title: "Error", okTitle: "Ok")
            }
        }
    }
    
    private func updateImage() {
        if completed {
            self.checkbox.setImage(AppAssets.checkmarkSquare, for: .normal)
        } else {
            self.checkbox.setImage(clearImage, for: .normal)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc private func deleteButtonTapped() {
        delete.send()
    }
}

extension EditTaskVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

