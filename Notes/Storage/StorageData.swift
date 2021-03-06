//
//  StorageData.swift
//  Notes
//
//  Created by Ольга on 23.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import RxSwift

protocol StorageType {
    func list() -> Observable<[Task]>
    func update(content: String) -> Observable<Task>
    func cancel() -> Observable<Task>
    func delete(task: Task) -> Observable<Task>
}

class StorageData: StorageType {
    
    var dataManager = DataManager()
    
    private var listOfTasks: [Task] = [] {
        didSet {
            dataManager.saveEvents(listOfTasks)
        }
    }
    
    private lazy var tasks = BehaviorSubject<[Task]>(value: [])
    
    var disposeBag = DisposeBag()
    
    func list() -> Observable<[Task]> {

        listOfTasks = dataManager.loadEvents() ?? listOfTasks
        print(listOfTasks)
        tasks.onNext(listOfTasks)
        return tasks.asObservable()
    }
    
    func update(content: String) -> Observable<Task> {
        listOfTasks.append(Task(content: content))
        tasks.onNext(listOfTasks)
        return Observable.just(Task(content: content))
    }
    
    func cancel() -> Observable<Task> {
        return Observable.never()
    }
    
    func delete(task: Task) -> Observable<Task> {
        
        if let index = listOfTasks.firstIndex(where: { $0.content == task.content }) {
            listOfTasks.remove(at: index)
        }
        
        tasks.onNext(listOfTasks)
        
        return Observable.just(task)
        
    }
}
