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
    
    private let storage: StorageType
    private let sceneCoordinator: SceneCoordinatorType
    
    init(title: String, storage: StorageType, sceneCoordinator: SceneCoordinatorType) {
        self.title = Observable.just(title)
        self.storage = storage
        self.sceneCoordinator = sceneCoordinator
    }
    
    private func update() -> Action<String, Void> {
         return Action { input in
            return self.storage.update(content: input).map { _ in }
         }
     }
     
    private func cancel() -> CocoaAction {
         return Action {
            return  self.storage.cancel().map { _ in}
         }
     }
    
    func createTask() -> CocoaAction {
        return CocoaAction { _ in
            let addTaskViewModel = AddTaskViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.update(), cancelAction: self.cancel())
            
            let addScene = Scene.add(addTaskViewModel)
            
            return self.sceneCoordinator.transition(to: addScene, using: .push, animated: true).asObservable().map { _ in }
        }
    }
    
    lazy var showDetail: Action<Task, Void> = {
           return Action { task in
               
            let detailViewModel = DetailTaskViewModel(task: task, sceneCoordinator: self.sceneCoordinator, storage: self.storage)
               
               let detailScene = Scene.detail(detailViewModel)
    
               return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map { _ in }
           }
       }()
}
