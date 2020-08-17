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

class TasksViewController: UIViewController {
    
    let cellId = "noteCell"
    
    var tasks: BehaviorRelay<[Task]> = BehaviorRelay(value: [])
    
    let disposeBag = DisposeBag()
    var tableView: UITableView!
    var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = barButtonItem
        bindTableView()
        bindAddTaskButtonTap()
    }
    
    
    @objc func addTask(barButtonItem: UIBarButtonItem) {}
    
    func bindAddTaskButtonTap() {
        barButtonItem.rx.tap.throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                
                guard let strongSelf = self else { return }
             
                let taskDetailsVC = AddTaskViewController()
                
                taskDetailsVC.task.subscribe(onNext :{ [weak self] task in
                    self?.tasks.add(element: task)

                    taskDetailsVC.dismiss(animated: true, completion: nil)
                    
                }).disposed(by: strongSelf.disposeBag)
                taskDetailsVC.modalPresentationStyle = .popover
                strongSelf.present(taskDetailsVC, animated: true, completion: nil)
                
        }.disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        tasks.asObservable().bind(to: tableView.rx.items(cellIdentifier: cellId)) { row, element, cell in
            cell.textLabel?.text = element.name

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
//MARK: - extension BehaviorRelay where Element
extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
