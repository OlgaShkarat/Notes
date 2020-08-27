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
    func delete() -> Observable<Task>
}

class StorageData: StorageType {
    
    private var listOfTasks = [Task]()
    private lazy var store = BehaviorSubject<[Task]>(value: [Task]())
    
    func list() -> Observable<[Task]> {
        return store.asObservable()
    }
    
    func update(content: String) -> Observable<Task> {
        let updated = Task(content: content)
        listOfTasks.append(updated)
        store.onNext(listOfTasks)
        return Observable.just(updated)
    }
    
    func delete() -> Observable<Task> {
        return Observable.never()
    }
}
