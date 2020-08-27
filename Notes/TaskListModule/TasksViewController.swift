//
//  TasksViewController.swift
//  Notes
//
//  Created by Ольга on 16.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class TasksViewController: UIViewController, ViewModelBindableType {
    
    let cellId = "noteCell"
 
    let disposeBag = DisposeBag()
    var tableView: UITableView!
    var viewModel: TaskListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        navigationItem.rightBarButtonItem  =  UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    
    func bindViewModel() {
        viewModel.title.drive(navigationItem.rx.title).disposed(by: disposeBag)
        navigationItem.rightBarButtonItem?.rx.action = viewModel.createTask()
        
        viewModel.taskList
            .bind(to: tableView.rx.items(cellIdentifier: cellId)) { row, task, cell in
                cell.textLabel?.text = task.content
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
}

