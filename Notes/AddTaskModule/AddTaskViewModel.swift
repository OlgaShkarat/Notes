//
//  AddTaskViewModel.swift
//  Notes
//
//  Created by Ольга on 23.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class AddTaskViewModel {
    
    private let storage: StorageType
    private let sceneCoordinator: SceneCoordinatorType
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction

    
    init(sceneCoordinator: SceneCoordinatorType, storage: StorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                UserDefaults.standard.set(input, forKey: "task")
                action.execute(input)
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute()
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
    }
}
