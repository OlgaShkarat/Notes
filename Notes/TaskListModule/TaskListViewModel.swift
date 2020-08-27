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
    
    func perforUpdate() -> Action<String, Void> {
         return Action { input in
            return self.storage.update(content: input).map { _ in }
         }
     }
     
    func performCancel() -> CocoaAction {
         return Action {
            return  self.storage.delete().map { _ in}
         }
     }
    
    func createTask() -> CocoaAction {
        
        return CocoaAction { _ in
            let addTaskViewModel = AddTaskViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.perforUpdate(), cancelAction: self.performCancel())
            
            let addScene = Scene.add(addTaskViewModel)
            
            return self.sceneCoordinator.transition(to: addScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }
}
