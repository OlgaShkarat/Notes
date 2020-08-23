//
//  SceneDelegate.swift
//  Notes
//
//  Created by Ольга on 16.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let coordinator = SceneCoordinator(window: window!)
        window?.windowScene = windowScene
        let storage = StorageData()
        let listViewModel = TaskListViewModel(title: "Задачи", storage: storage, sceneCoordinator: coordinator)
        let listScene = Scene.list(listViewModel)
        coordinator.transition(to: listScene, using: .root, animated: true).subscribe().disposed(by: disposeBag)
    }
}
