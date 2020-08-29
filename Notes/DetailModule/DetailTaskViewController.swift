//
//  DetailTaskViewController.swift
//  Notes
//
//  Created by Ольга on 28.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import UIKit
import RxSwift

class DetailTaskViewController: UIViewController, ViewModelBindableType {

    var viewModel: DetailTaskViewModel!
    private let disposeBag = DisposeBag()
    
    private let taskTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .systemBlue
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 18)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: nil, action: nil)
        
        view.addSubview(taskTextView)
        NSLayoutConstraint.activate([
            taskTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            taskTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func bindViewModel() {
        navigationItem.leftBarButtonItem?.rx.action = viewModel.cancelAction
        viewModel.content.bind { (name) in
            self.taskTextView.text = name
        }.disposed(by: disposeBag)
    }
}
