//
//  TaskListViewModel.swift
//  Notes
//
//  Created by Ольга on 22.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class TaskListViewModel {
 
    var title: Driver<String>
    
    var taskList: Observable<[Task]> {
        return storage.list()
    }
    
    let storage: StorageType
    let sceneCoordinator: SceneCoordinatorType
    
    init(title: String, storage: StorageType, sceneCoordinator: SceneCoordinatorType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.storage = storage
        self.sceneCoordinator = sceneCoordinator
    }
    
    func perforUpdate(task: Task) -> Action<String, Void> {
         return Action { input in
            return self.storage.update(task: task, content: input).map { _ in }
         }
     }
     
    func performCancel(task: Task) -> CocoaAction {
         return Action {
            return  self.storage.delete(task: task).map { _ in}
         }
     }
    
    func createTask() -> CocoaAction {
        
        return CocoaAction { _ in
            return self.storage.create(content: "")
                .flatMap { task -> Observable<Void> in
                    let addTaskViewModel = AddTaskViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.perforUpdate(task: task), cancelAction: self.performCancel(task: task))
    
                    let addScene = Scene.add(addTaskViewModel)
                    
                    return self.sceneCoordinator.transition(to: addScene, using: .modal, animated: true).asObservable().map { _ in }
            }
        }
    }
}
