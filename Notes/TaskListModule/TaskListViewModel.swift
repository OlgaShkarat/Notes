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
 
    var title: Observable<String>
    
    var taskList: Observable<[Task]> {
        return storage.list()
    }
    
    let storage: StorageType
    let sceneCoordinator: SceneCoordinatorType
    
    init(title: String, storage: StorageType, sceneCoordinator: SceneCoordinatorType) {
        self.title = Observable.just(title)
        self.storage = storage
        self.sceneCoordinator = sceneCoordinator
    }
    
    func update() -> Action<String, Void> {
         return Action { input in
            return self.storage.update(content: input).map { _ in }
         }
     }
     
    func cancel() -> CocoaAction {
         return Action {
            return  self.storage.cancel().map { _ in}
         }
     }
    
    func createTask() -> CocoaAction {
        return CocoaAction { _ in
            let addTaskViewModel = AddTaskViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.update(), cancelAction: self.cancel())
            
            let addScene = Scene.add(addTaskViewModel)
            
            return self.sceneCoordinator.transition(to: addScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }
}
