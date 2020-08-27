//
//  AddTaskViewController.swift
//  Notes
//
//  Created by Ольга on 16.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddTaskViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: AddTaskViewModel!
    let disposeBag = DisposeBag()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Task name"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(textField)
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Удалить", style: .done, target: nil, action: nil)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func bindViewModel() {
        navigationItem.leftBarButtonItem?.rx.action = viewModel.cancelAction
        navigationItem.rightBarButtonItem?.rx.tap
            .throttle(.microseconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: disposeBag)
    }
}
