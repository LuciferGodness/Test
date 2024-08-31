//
//  BaseVC.swift
//  ToDoList
//
//  Created by Admin on 8/31/24.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    private let loadingIndicator = UIActivityIndicatorView()
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    var isNavigationBarLeftButton: Bool {
        true
    }
    
    var isNavigationBarHidden: Bool {
        false
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
    }
    
    func startLoading() {
        loadingIndicator.color = .black
        loadingIndicator.startAnimating()
    }
    
    func endLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func showAlert(message: String?, _ completion: (() -> Void)?, title: String?, okTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okTitle, style: .default) {_ in
            completion?()
        })
        
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        setupLoadingIndicator()
        super.viewDidLoad()
        setupNavigationBar()
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
}
