//
//  StorageData.swift
//  Notes
//
//  Created by Ольга on 23.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import RxSwift

protocol StorageType {
    func create(content: String) -> Observable<Task>
    func list() -> Observable<[Task]>
    func update(task: Task, content: String) -> Observable<Task>
    func delete(task: Task) -> Observable<Task>
}

class StorageData: StorageType {
    
    private var listOfTasks = [Task(content: "Сделать дом/задание")]
    private lazy var store = BehaviorSubject<[Task]>(value: listOfTasks)
    
    func create(content: String) -> Observable<Task> {
        let newTask = Task(content: content)
        listOfTasks.insert(newTask, at: 0)
        return Observable.just(newTask)
    }
    
    func list() -> Observable<[Task]> {
        return store.asObservable()
    }
    
    func update(task: Task, content: String) -> Observable<Task> {
        let updated = Task(original: task, updateContent: content)
        
        if let index = listOfTasks.firstIndex(where: { $0 == task }) {
            listOfTasks.remove(at: index)
            listOfTasks.insert(updated, at: index)
        }
        
        store.onNext(listOfTasks)
        
        return Observable.just(updated)
    }
    
    func delete(task: Task) -> Observable<Task> {
        if let index = listOfTasks.firstIndex(where: { $0 == task }) {
            listOfTasks.remove(at: index)
        }
        
        store.onNext(listOfTasks)
        
        return Observable.just(task)
    }
}
