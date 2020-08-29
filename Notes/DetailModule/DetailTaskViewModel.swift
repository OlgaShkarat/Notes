//
//  DetailTaskViewModel.swift
//  Notes
//
//  Created by Ольга on 28.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import Foundation
import RxSwift
import Action

class DetailTaskViewModel {
    
    private let storage: StorageType
    private let sceneCoordinator: SceneCoordinatorType
    let cancelAction: CocoaAction
    
    var content: BehaviorSubject<String>
    
    init(task: Task, sceneCoordinator: SceneCoordinatorType, storage: StorageType, cancelAction: CocoaAction? = nil) {
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
        content = BehaviorSubject<String>(value: task.content)
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute()
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
    }
}
