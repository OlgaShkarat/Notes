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
    
    let storage: StorageType
    let sceneCoordinator: SceneCoordinatorType
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction

    private let content: String?
    
    init(content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: StorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        
        self.content = content
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
        
        
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
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
